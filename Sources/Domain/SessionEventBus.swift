//
//  SessionEventBus.swift
//  Domain
//
//  A type-safe, AsyncStream-powered event bus for session-level events.
//  Lives in Domain so both Data (sender) and Presentation (observer)
//  can use it without cross-layer coupling.
//

import Foundation

// MARK: - Events

/// All session-level events that the networking layer can emit.
/// Add new cases here as needs grow (e.g. `.tokenRefreshed`, `.forceUpdate`).
public enum SessionEvent: Sendable {
    case unauthorized   // 401 received — session expired / invalid
}

// MARK: - Event Bus

/// Thread-safe, singleton event bus.
/// - **Data layer** calls `SessionEventBus.shared.send(.unauthorized)`
/// - **Presentation layer** iterates `SessionEventBus.shared.events` in a Task
public final class SessionEventBus: Sendable {

    public static let shared = SessionEventBus()

    /// The stream that observers `for await` on.
    public let events: AsyncStream<SessionEvent>

    /// Private continuation used to yield new events into the stream.
    private let continuation: AsyncStream<SessionEvent>.Continuation

    private init() {
        let (stream, continuation) = AsyncStream.makeStream(of: SessionEvent.self)
        self.events = stream
        self.continuation = continuation
    }

    /// Fire an event. Safe to call from any thread / actor context.
    public func send(_ event: SessionEvent) {
        continuation.yield(event)
    }
}
