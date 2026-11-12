//
//  UnregisterPushTokenUseCase.swift
//  Domain
//
//  Created by SafeCircle Team.
//

import Foundation

public protocol UnregisterPushTokenUseCase: Sendable {
    func execute(token: String) async throws
}

public struct DefaultUnregisterPushTokenUseCase: UnregisterPushTokenUseCase {
    private let repository: PushNotificationRepository

    public init(repository: PushNotificationRepository) {
        self.repository = repository
    }

    public func execute(token: String) async throws {
        try await repository.unregisterPushToken(token: token)
    }
}
