//
//  PushNotificationRepoImpl.swift
//  Data
//
//  Created by SafeCircle Team.
//

import Foundation
import Domain

final class PushNotificationRepoImpl: PushNotificationRepository {
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient = NetworkExecutor1()) {
        self.networkClient = networkClient
    }

    func registerPushToken(
        token: String,
        platform: String,
        appRole: String,
        deviceId: String?,
        appVersion: String?
    ) async throws -> PushDeviceEntity {
        let request = RegisterPushTokenRequest(
            token: token,
            platform: platform,
            appRole: appRole,
            deviceId: deviceId,
            appVersion: appVersion
        )
        let response: PushDeviceResponseDTO = try await networkClient.execute(request)
        guard let entity = response.toEntity() else {
            throw NetworkError.decodingFailed
        }
        return entity
    }

    func unregisterPushToken(token: String) async throws {
        let request = UnregisterPushTokenRequest(token: token)
        let _: DefaultResponseDTO = try await networkClient.execute(request)
    }

    func testPush() async throws {
        let request = TestPushRequest()
        let _: DefaultResponseDTO = try await networkClient.execute(request)
    }
}
