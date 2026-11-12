//
//  PushDeviceDTO.swift
//  Data
//
//  Created by SafeCircle Team.
//

import Foundation
import Domain

struct PushDeviceDTO: Decodable, Sendable {
    let id: String
    let platform: String
    let appRole: String
    let deviceId: String?
    let appVersion: String?
    let isActive: Bool
    let lastSeenAt: String?
    let tokenPreview: String

    enum CodingKeys: String, CodingKey {
        case id
        case platform
        case appRole = "app_role"
        case deviceId = "device_id"
        case appVersion = "app_version"
        case isActive = "is_active"
        case lastSeenAt = "last_seen_at"
        case tokenPreview = "token_preview"
    }

    func toEntity() -> PushDeviceEntity {
        PushDeviceEntity(
            id: id,
            platform: platform,
            appRole: appRole,
            deviceId: deviceId,
            appVersion: appVersion,
            isActive: isActive,
            lastSeenAt: lastSeenAt,
            tokenPreview: tokenPreview
        )
    }
}

struct PushDeviceResponseDTO: Decodable, Sendable {
    let success: Bool?
    let message: String?
    let data: PushDeviceDTO?

    func toEntity() -> PushDeviceEntity? {
        data?.toEntity()
    }
}
