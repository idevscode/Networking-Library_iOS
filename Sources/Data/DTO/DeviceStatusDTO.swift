//
//  DeviceStatusDTO.swift
//  Data
//
//  Created by SafeCircle Team.
//

import Foundation
import Domain

struct DeviceStatusDTO: Decodable, Sendable {
    let batteryLevel: Int?
    let isCharging: Bool?
    let gpsEnabled: Bool?
    let locationPermission: String?
    let appState: String?
    let networkType: String?

    enum CodingKeys: String, CodingKey {
        case batteryLevel = "battery_level"
        case isCharging = "is_charging"
        case gpsEnabled = "gps_enabled"
        case locationPermission = "location_permission"
        case appState = "app_state"
        case networkType = "network_type"
    }

    func toEntity() -> DeviceStatusEntity {
        return DeviceStatusEntity(
            batteryLevel: batteryLevel ?? 100,
            isCharging: isCharging ?? false,
            gpsEnabled: gpsEnabled ?? true,
            locationPermission: locationPermission ?? "unknown",
            appState: appState ?? "unknown",
            networkType: networkType ?? "unknown"
        )
    }
}

struct DeviceStatusResponseDTO: Decodable, Sendable {
    let success: Bool
    let message: String
    let data: DeviceStatusDTO?

    func toEntity() -> DeviceStatusEntity? {
        data?.toEntity()
    }
}
