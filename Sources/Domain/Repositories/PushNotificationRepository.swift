//
//  PushNotificationRepository.swift
//  Domain
//
//  Created by SafeCircle Team.
//

import Foundation

public protocol PushNotificationRepository: Sendable {
    /// Register or refresh this device's push token with backend
    func registerPushToken(
        token: String,
        platform: String,
        appRole: String,
        deviceId: String?,
        appVersion: String?
    ) async throws -> PushDeviceEntity

    /// Stop alerts on this device (call on logout)
    func unregisterPushToken(token: String) async throws

    /// Send myself a test alert
    func testPush() async throws
}
