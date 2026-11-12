//
//  DeviceStatusEntity.swift
//  Domain
//
//  Created by SafeCircle Team.
//

import Foundation

public struct DeviceStatusEntity: Codable, Sendable {
    public let batteryLevel: Int
    public let isCharging: Bool
    public let gpsEnabled: Bool
    public let locationPermission: String  // "always" | "whenInUse" | "denied"
    public let appState: String            // "foreground" | "background" | "inactive"
    public let networkType: String         // "wifi" | "cellular_5g" | "cellular_4g" | "none"

    public init(
        batteryLevel: Int,
        isCharging: Bool,
        gpsEnabled: Bool,
        locationPermission: String,
        appState: String,
        networkType: String
    ) {
        self.batteryLevel = batteryLevel
        self.isCharging = isCharging
        self.gpsEnabled = gpsEnabled
        self.locationPermission = locationPermission
        self.appState = appState
        self.networkType = networkType
    }
}
