//
//  JourneyEntity.swift
//  Domain
//
//  Created by Dilshad Haidari on 26/09/26.
//

import Foundation

public struct RouteCoordinateEntity: Codable, Sendable, Hashable {
    public let lat: Double
    public let lng: Double
    
    public init(lat: Double, lng: Double) {
        self.lat = lat
        self.lng = lng
    }
}

public struct JourneyWaypointEntity: Codable, Sendable, Hashable {
    public let lat: Double
    public let lng: Double
    public let label: String
    
    public init(lat: Double, lng: Double, label: String) {
        self.lat = lat
        self.lng = lng
        self.label = label
    }
}

public struct JourneyShareEntity: Identifiable, Codable, Sendable, Hashable {
    public var id: String { guardianId }
    public let guardianId: String
    public let guardianName: String
    public let shareToken: String
    public let websocketUrl: String
    public let expiresInHours: Int
    
    public init(
        guardianId: String,
        guardianName: String,
        shareToken: String,
        websocketUrl: String,
        expiresInHours: Int
    ) {
        self.guardianId = guardianId
        self.guardianName = guardianName
        self.shareToken = shareToken
        self.websocketUrl = websocketUrl
        self.expiresInHours = expiresInHours
    }
}

public struct JourneyEntity: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public let userId: String
    public let startLabel: String
    public let startLat: Double
    public let startLng: Double
    public let endLabel: String
    public let endLat: Double
    public let endLng: Double
    public let plannedRoute: [RouteCoordinateEntity]
    public let plannedDistanceM: Double
    public let expectedDurationMinutes: Int
    public let status: String
    public let startedAt: String
    public let endedAt: String?
    public let isDeviated: Bool
    public let deviationCount: Int
    public let lastDeviationAt: String?
    public let maxDeviationM: Double
    public let lastPingAt: String?
    public let pingCount: Int
    
    public init(
        id: String,
        userId: String,
        startLabel: String,
        startLat: Double,
        startLng: Double,
        endLabel: String,
        endLat: Double,
        endLng: Double,
        plannedRoute: [RouteCoordinateEntity],
        plannedDistanceM: Double,
        expectedDurationMinutes: Int,
        status: String,
        startedAt: String,
        endedAt: String? = nil,
        isDeviated: Bool = false,
        deviationCount: Int = 0,
        lastDeviationAt: String? = nil,
        maxDeviationM: Double = 0,
        lastPingAt: String? = nil,
        pingCount: Int = 0
    ) {
        self.id = id
        self.userId = userId
        self.startLabel = startLabel
        self.startLat = startLat
        self.startLng = startLng
        self.endLabel = endLabel
        self.endLat = endLat
        self.endLng = endLng
        self.plannedRoute = plannedRoute
        self.plannedDistanceM = plannedDistanceM
        self.expectedDurationMinutes = expectedDurationMinutes
        self.status = status
        self.startedAt = startedAt
        self.endedAt = endedAt
        self.isDeviated = isDeviated
        self.deviationCount = deviationCount
        self.lastDeviationAt = lastDeviationAt
        self.maxDeviationM = maxDeviationM
        self.lastPingAt = lastPingAt
        self.pingCount = pingCount
    }
}

public struct StartJourneyResponseEntity: Sendable {
    public let success: Bool
    public let message: String
    public let journey: JourneyEntity
    public let shares: [JourneyShareEntity]
    
    public init(
        success: Bool,
        message: String,
        journey: JourneyEntity,
        shares: [JourneyShareEntity]
    ) {
        self.success = success
        self.message = message
        self.journey = journey
        self.shares = shares
    }
}
