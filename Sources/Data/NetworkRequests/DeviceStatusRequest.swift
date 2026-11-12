//
//  DeviceStatusRequest.swift
//  Data
//
//  Created by SafeCircle Team.
//

import Foundation
import Domain

struct DeviceStatusRequest: RequestProtocol, Sendable {
    let journeyId: String
    let status: DeviceStatusEntity

    var path: String {
        "api/v1/journeys/\(journeyId)/device-status"
    }

    var methodType: HTTPMethodType {
        .POST
    }

    var parameters: [String: Any]? {
        [
            "battery_level": status.batteryLevel,
            "is_charging": status.isCharging,
            "gps_enabled": status.gpsEnabled,
            "location_permission": status.locationPermission,
            "app_state": status.appState,
            "network_type": status.networkType
        ]
    }
}
