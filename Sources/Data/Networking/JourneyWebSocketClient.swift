//
//  JourneyWebSocketClient.swift
//  Data
//
//  Created by SafeCircle Team on 18/10/26.
//

import Foundation
import Combine
import Domain

public final class JourneyWebSocketClient: NSObject, JourneyWebSocketClientProtocol, @unchecked Sendable {

    // MARK: - Properties

    private var session: URLSession?
    private var webSocketTask: URLSessionWebSocketTask?
    private var pingTimer: Timer?
    private var currentURL: URL?
    private var shouldReconnect: Bool = true
    private var reconnectAttempt: Int = 0
    private let maxReconnectAttempts: Int = 5
    private var isManuallyDisconnected: Bool = false

    private let eventSubject = PassthroughSubject<JourneyLiveEvent, Never>()
    private let disconnectionSubject = PassthroughSubject<Int, Never>()
    private var streamContinuation: AsyncStream<JourneyLiveEvent>.Continuation?

    private let lock = NSLock()
    private var _isConnected: Bool = false

    public var isConnected: Bool {
        lock.lock()
        defer { lock.unlock() }
        return _isConnected
    }

    public var eventsPublisher: AnyPublisher<JourneyLiveEvent, Never> {
        eventSubject.eraseToAnyPublisher()
    }

    public var disconnectionPublisher: AnyPublisher<Int, Never> {
        disconnectionSubject.eraseToAnyPublisher()
    }

    public lazy var events: AsyncStream<JourneyLiveEvent> = {
        AsyncStream { continuation in
            self.streamContinuation = continuation
        }
    }()

    // MARK: - Initializer

    public override init() {
        super.init()
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30.0
        self.session = URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }

    deinit {
        disconnect()
    }

    // MARK: - URL Resolution Helper

    public static func resolveWebSocketURL(from baseURLString: String, websocketPathWithQuery: String) -> URL? {
        let trimmedPath = websocketPathWithQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedPath.isEmpty else { return nil }

        // If it's already an absolute ws:// or wss:// URL
        if trimmedPath.hasPrefix("ws://") || trimmedPath.hasPrefix("wss://") {
            return URL(string: trimmedPath)
        }

        // If it's http:// or https://, swap scheme to ws/wss
        if trimmedPath.hasPrefix("http://") {
            let wsString = "ws" + trimmedPath.dropFirst(4)
            return URL(string: wsString)
        }
        if trimmedPath.hasPrefix("https://") {
            let wssString = "wss" + trimmedPath.dropFirst(5)
            return URL(string: wssString)
        }

        // Otherwise resolve against baseURLString
        guard let baseURL = URL(string: baseURLString),
              let host = baseURL.host else {
            return nil
        }

        let isSecure = baseURL.scheme?.lowercased() == "https"
        let scheme = isSecure ? "wss" : "ws"
        let portPart = baseURL.port != nil ? ":\(baseURL.port!)" : ""
        let formattedPath = trimmedPath.hasPrefix("/") ? trimmedPath : "/\(trimmedPath)"

        let fullString = "\(scheme)://\(host)\(portPart)\(formattedPath)"
        return URL(string: fullString)
    }

    // MARK: - Connect & Disconnect

    public func connect(url: URL) async throws {
        prepareConnectionState(for: url)
        internalConnect(to: url)
    }

    private func prepareConnectionState(for url: URL) {
        lock.lock()
        defer { lock.unlock() }
        self.currentURL = url
        self.isManuallyDisconnected = false
        self.shouldReconnect = true
        self.reconnectAttempt = 0
    }

    private func internalConnect(to url: URL) {
        lock.lock()
        webSocketTask?.cancel(with: .normalClosure, reason: nil)
        stopPingTimer()

        let task = session?.webSocketTask(with: url)
        self.webSocketTask = task
        lock.unlock()

        task?.resume()
        listenForMessages()
        startPingTimer()
    }

    public func disconnect() {
        lock.lock()
        isManuallyDisconnected = true
        shouldReconnect = false
        _isConnected = false
        stopPingTimer()
        let task = webSocketTask
        webSocketTask = nil
        lock.unlock()

        task?.cancel(with: .normalClosure, reason: "Client requested disconnect".data(using: .utf8))
    }

    // MARK: - Keepalive Ping

    public func sendPing() async throws {
        guard let task = webSocketTask else { return }
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            task.send(.string("ping")) { error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: ())
                }
            }
        }
    }

    private func startPingTimer() {
        stopPingTimer()
        DispatchQueue.main.async { [weak self] in
            // PDF Spec: "Send the text ping every ~25 seconds. The server replies {"event":"pong"}."
            self?.pingTimer = Timer.scheduledTimer(withTimeInterval: 25.0, repeats: true) { [weak self] _ in
                Task { [weak self] in
                    try? await self?.sendPing()
                }
            }
        }
    }

    private func stopPingTimer() {
        DispatchQueue.main.async { [weak self] in
            self?.pingTimer?.invalidate()
            self?.pingTimer = nil
        }
    }

    // MARK: - Message Loop

    private func listenForMessages() {
        guard let task = webSocketTask else { return }

        task.receive { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let message):
                self.handleIncomingMessage(message)
                self.listenForMessages()

            case .failure(let error):
                self.handleConnectionFailure(error: error)
            }
        }
    }

    private func handleIncomingMessage(_ message: URLSessionWebSocketTask.Message) {
        let data: Data
        switch message {
        case .string(let text):
            print("JourneyWebSocketClient: Received WebSocket text: \(text)")
            // Check for pong
            if text.contains("\"event\":\"pong\"") || text.trimmingCharacters(in: .whitespacesAndNewlines) == "pong" {
                return
            }
            guard let textData = text.data(using: .utf8) else { return }
            data = textData
        case .data(let rawData):
            if let str = String(data: rawData, encoding: .utf8) {
                print("JourneyWebSocketClient: Received WebSocket binary string: \(str)")
            }
            data = rawData
        @unknown default:
            return
        }

        guard let envelope = try? JSONDecoder().decode(JourneyWebSocketEnvelopeDTO.self, from: data) else {
            if let rawStr = String(data: data, encoding: .utf8) {
                print("JourneyWebSocketClient: Failed to decode envelope from raw JSON: \(rawStr)")
            }
            return
        }

        setConnected(true)

        let journeyId = envelope.journeyId ?? ""
        guard let subData = envelope.rawData else { return }
        let decoder = JSONDecoder()

        switch envelope.event {
        case "journey.snapshot":
            do {
                let dto = try decoder.decode(JourneySnapshotEventDTO.self, from: subData)
                let entity = dto.toEntity(fallbackId: journeyId)
                dispatchLiveEvent(.snapshot(entity))
            } catch {
                print("JourneyWebSocketClient: Failed to decode journey.snapshot: \(error)")
            }

        case "journey.location":
            do {
                let dto = try decoder.decode(JourneyLocationEventDTO.self, from: subData)
                let entity = dto.toEntity()
                dispatchLiveEvent(.location(entity))
            } catch {
                print("JourneyWebSocketClient: Failed to decode journey.location: \(error)")
            }

        case "journey.deviation":
            do {
                let dto = try decoder.decode(JourneyDeviationEventDTO.self, from: subData)
                let entity = dto.toEntity()
                dispatchLiveEvent(.deviation(entity))
            } catch {
                print("JourneyWebSocketClient: Failed to decode journey.deviation: \(error)")
            }

        case "risk.detected":
            do {
                let dto = try decoder.decode(JourneyRiskEventDTO.self, from: subData)
                let entity = dto.toEntity()
                dispatchLiveEvent(.risk(entity))
            } catch {
                print("JourneyWebSocketClient: Failed to decode risk.detected: \(error)")
            }

        case "journey.ended":
            do {
                let dto = try decoder.decode(JourneyEndedEventDTO.self, from: subData)
                let entity = dto.toEntity()
                dispatchLiveEvent(.ended(entity))
                disconnect()
            } catch {
                print("JourneyWebSocketClient: Failed to decode journey.ended: \(error)")
            }

        case "pong":
            break

        default:
            // PDF Spec: Ignore unrecognized events (risk.resolved, risk.acknowledged, checkin.prompt, etc.) without treating as error
            break
        }
    }

    private func dispatchLiveEvent(_ event: JourneyLiveEvent) {
        eventSubject.send(event)
        streamContinuation?.yield(event)
    }

    private func setConnected(_ connected: Bool) {
        lock.lock()
        _isConnected = connected
        lock.unlock()
    }

    // MARK: - Reconnection & Errors

    private func handleConnectionFailure(error: Error) {
        let nsError = error as NSError
        print("JourneyWebSocketClient: WebSocket receive completed with error: \(error.localizedDescription) (Domain: \(nsError.domain), Code: \(nsError.code))")

        // 1. If cancelled intentionally (e.g. during disconnect or reconnect), DO NOT treat as disconnect event
        if nsError.domain == NSURLErrorDomain && nsError.code == NSURLErrorCancelled {
            print("JourneyWebSocketClient: Task cancelled as expected.")
            return
        }

        lock.lock()
        let manual = isManuallyDisconnected
        lock.unlock()

        if manual {
            return
        }

        setConnected(false)
        stopPingTimer()

        // 2. Broadcast abnormal closure code 1006
        disconnectionSubject.send(URLSessionWebSocketTask.CloseCode.abnormalClosure.rawValue)
    }
}

// MARK: - URLSessionWebSocketDelegate

extension JourneyWebSocketClient: URLSessionWebSocketDelegate {
    public func urlSession(
        _ session: URLSession,
        webSocketTask: URLSessionWebSocketTask,
        didOpenWithProtocol protocol: String?
    ) {
        setConnected(true)
    }

    public func urlSession(
        _ session: URLSession,
        webSocketTask: URLSessionWebSocketTask,
        didCloseWith closeCode: URLSessionWebSocketTask.CloseCode,
        reason: Data?
    ) {
        let reasonStr = reason.flatMap { String(data: $0, encoding: .utf8) } ?? "none"
        print("JourneyWebSocketClient: WebSocket closed by server with code: \(closeCode.rawValue), reason: \(reasonStr)")
        setConnected(false)
        stopPingTimer()

        // Close Code 1008 = Policy Violation (token invalid/expired, consent revoked)
        if closeCode.rawValue == 1008 {
            lock.lock()
            shouldReconnect = false
            lock.unlock()
        }

        disconnectionSubject.send(closeCode.rawValue)
    }
}
