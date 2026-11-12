//
//  JourneyWebSocketClientProtocol.swift
//  Domain
//
//  Created by SafeCircle Team on 18/10/26.
//

import Foundation
import Combine

public protocol JourneyWebSocketClientProtocol: Sendable {
    var isConnected: Bool { get }
    func connect(url: URL) async throws
    func disconnect()
    func sendPing() async throws
    var events: AsyncStream<JourneyLiveEvent> { get }
    var eventsPublisher: AnyPublisher<JourneyLiveEvent, Never> { get }
    var disconnectionPublisher: AnyPublisher<Int, Never> { get }
}
