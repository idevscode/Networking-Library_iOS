//
//  BiometricEnrolEntity.swift
//  Domain
//
//  Created by Dilshad Haidari on 31/08/26.
//

import Foundation

public struct BiometricEnrolResponseEntity: Sendable {
    public let success: Bool
    public let message: String
    public let device: BiometricDeviceEntity
    
    public init(success: Bool, message: String, device: BiometricDeviceEntity) {
        self.success = success
        self.message = message
        self.device = device
    }
}

public struct BiometricDeviceEntity: Sendable {
    public let id: String
    public let deviceId: String
    public let deviceName: String
    public let platform: String
    public let algorithm: String
    public let lastUsedAt: String?
    public let createdAt: String?
    
    public init(
        id: String,
        deviceId: String,
        deviceName: String,
        platform: String,
        algorithm: String,
        lastUsedAt: String? = nil,
        createdAt: String? = nil
    ) {
        self.id = id
        self.deviceId = deviceId
        self.deviceName = deviceName
        self.platform = platform
        self.algorithm = algorithm
        self.lastUsedAt = lastUsedAt
        self.createdAt = createdAt
    }
}
