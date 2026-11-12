//
//  RegisterPushTokenUseCase.swift
//  Domain
//
//  Created by SafeCircle Team.
//

import Foundation

public protocol RegisterPushTokenUseCase: Sendable {
    func execute(
        token: String,
        platform: String,
        appRole: String,
        deviceId: String?,
        appVersion: String?
    ) async throws -> PushDeviceEntity
}

public struct DefaultRegisterPushTokenUseCase: RegisterPushTokenUseCase {
    private let repository: PushNotificationRepository

    public init(repository: PushNotificationRepository) {
        self.repository = repository
    }

    public func execute(
        token: String,
        platform: String = "ios",
        appRole: String = "user",
        deviceId: String? = nil,
        appVersion: String? = nil
    ) async throws -> PushDeviceEntity {
        try await repository.registerPushToken(
            token: token,
            platform: platform,
            appRole: appRole,
            deviceId: deviceId,
            appVersion: appVersion
        )
    }
}
