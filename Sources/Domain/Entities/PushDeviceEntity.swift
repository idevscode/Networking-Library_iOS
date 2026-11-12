//
//  PushDeviceEntity.swift
//  Domain
//
//  Created by SafeCircle Team.
//

import Foundation

public struct PushDeviceEntity: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public let platform: String
    public let appRole: String
    public let deviceId: String?
    public let appVersion: String?
    public let isActive: Bool
    public let lastSeenAt: String?
    public let tokenPreview: String

    public init(
        id: String,
        platform: String,
        appRole: String,
        deviceId: String? = nil,
        appVersion: String? = nil,
        isActive: Bool = true,
        lastSeenAt: String? = nil,
        tokenPreview: String
    ) {
        self.id = id
        self.platform = platform
        self.appRole = appRole
        self.deviceId = deviceId
        self.appVersion = appVersion
        self.isActive = isActive
        self.lastSeenAt = lastSeenAt
        self.tokenPreview = tokenPreview
    }
}
