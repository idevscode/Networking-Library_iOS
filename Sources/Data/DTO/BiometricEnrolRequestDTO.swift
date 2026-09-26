//
//  BiometricEnrolRequestDTO.swift
//  Data
//
//  Created by Dilshad Haidari on 31/08/26.
//

import Foundation
import Domain

// POST /api/v1/auth/biometric/enrol Response
nonisolated public struct BiometricEnrolResponseDTO: Decodable, Sendable {
    public let success: Bool
    public let message: String
    public let data: BiometricDeviceDTO
    
    enum CodingKeys: String, CodingKey {
        case success
        case message
        case data
    }
    
    public func toEntity() -> BiometricEnrolResponseEntity {
        BiometricEnrolResponseEntity(
            success: success,
            message: message,
            device: data.toEntity()
        )
    }
}

nonisolated public struct BiometricDeviceDTO: Decodable, Sendable {
    public let id: String
    public let deviceId: String
    public let deviceName: String
    public let platform: String
    public let algorithm: String
    public let lastUsedAt: String?
    public let createdAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case deviceId = "device_id"
        case deviceName = "device_name"
        case platform
        case algorithm
        case lastUsedAt = "last_used_at"
        case createdAt = "created_at"
    }
    
    public func toEntity() -> BiometricDeviceEntity {
        BiometricDeviceEntity(
            id: id,
            deviceId: deviceId,
            deviceName: deviceName,
            platform: platform,
            algorithm: algorithm,
            lastUsedAt: lastUsedAt,
            createdAt: createdAt
        )
    }
}
