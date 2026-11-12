//
//  JourneyLiveEventEntity.swift
//  Domain
//
//  Created by SafeCircle Team on 18/10/26.
//

import Foundation

public struct JourneyLiveLocationEntity: Codable, Sendable, Hashable {
    public let lat: Double
    public let lng: Double
    public let accuracyM: Double
    public let speedMps: Double
    public let heading: Double
    public let batteryLevel: Int
    public let recordedAt: String
    public let isDeviated: Bool
    public let pingCount: Int

    public init(
        lat: Double,
        lng: Double,
        accuracyM: Double = 5.0,
        speedMps: Double = 0.0,
        heading: Double = 0.0,
        batteryLevel: Int = 100,
        recordedAt: String = "",
        isDeviated: Bool = false,
        pingCount: Int = 0
    ) {
        self.lat = lat
        self.lng = lng
        self.accuracyM = accuracyM
        self.speedMps = speedMps
        self.heading = heading
        self.batteryLevel = batteryLevel
        self.recordedAt = recordedAt
        self.isDeviated = isDeviated
        self.pingCount = pingCount
    }
}

public struct JourneyLiveWaypointEntity: Codable, Sendable, Hashable {
    public let lat: Double
    public let lng: Double
    public let label: String

    public init(lat: Double, lng: Double, label: String) {
        self.lat = lat
        self.lng = lng
        self.label = label
    }
}

public struct JourneyLiveLastLocationEntity: Codable, Sendable, Hashable {
    public let lat: Double
    public let lng: Double
    public let accuracyM: Double?
    public let recordedAt: String?

    public init(
        lat: Double,
        lng: Double,
        accuracyM: Double? = nil,
        recordedAt: String? = nil
    ) {
        self.lat = lat
        self.lng = lng
        self.accuracyM = accuracyM
        self.recordedAt = recordedAt
    }
}

public struct JourneyLiveSnapshotEntity: Codable, Sendable, Hashable {
    public let journeyId: String
    public let status: String
    public let startedAt: String
    public let endedAt: String?
    public let start: JourneyLiveWaypointEntity?
    public let end: JourneyLiveWaypointEntity?
    public let plannedRoute: [RouteCoordinateEntity]
    public let isDeviated: Bool
    public let deviationCount: Int
    public let pingCount: Int
    public let lastLocation: JourneyLiveLastLocationEntity?

    public init(
        journeyId: String,
        status: String,
        startedAt: String,
        endedAt: String? = nil,
        start: JourneyLiveWaypointEntity? = nil,
        end: JourneyLiveWaypointEntity? = nil,
        plannedRoute: [RouteCoordinateEntity] = [],
        isDeviated: Bool = false,
        deviationCount: Int = 0,
        pingCount: Int = 0,
        lastLocation: JourneyLiveLastLocationEntity? = nil
    ) {
        self.journeyId = journeyId
        self.status = status
        self.startedAt = startedAt
        self.endedAt = endedAt
        self.start = start
        self.end = end
        self.plannedRoute = plannedRoute
        self.isDeviated = isDeviated
        self.deviationCount = deviationCount
        self.pingCount = pingCount
        self.lastLocation = lastLocation
    }
}

public struct JourneyLiveDeviationEntity: Codable, Sendable, Hashable {
    public let lat: Double
    public let lng: Double
    public let distanceFromRouteM: Double
    public let thresholdM: Double
    public let detectedAt: String
    public let deviationCount: Int

    public init(
        lat: Double,
        lng: Double,
        distanceFromRouteM: Double,
        thresholdM: Double,
        detectedAt: String = "",
        deviationCount: Int = 0
    ) {
        self.lat = lat
        self.lng = lng
        self.distanceFromRouteM = distanceFromRouteM
        self.thresholdM = thresholdM
        self.detectedAt = detectedAt
        self.deviationCount = deviationCount
    }
}

public struct JourneyLiveEndedEntity: Codable, Sendable, Hashable {
    public let status: String
    public let endedAt: String?
    public let pingCount: Int
    public let deviationCount: Int
    public let openRisksClosed: Bool?

    public init(
        status: String,
        endedAt: String? = nil,
        pingCount: Int = 0,
        deviationCount: Int = 0,
        openRisksClosed: Bool? = nil
    ) {
        self.status = status
        self.endedAt = endedAt
        self.pingCount = pingCount
        self.deviationCount = deviationCount
        self.openRisksClosed = openRisksClosed
    }
}

public struct JourneyLiveRiskEntity: Codable, Sendable, Hashable {
    public let type: String
    public let severity: String
    public let message: String
    public let lat: Double?
    public let lng: Double?

    public init(
        type: String = "risk",
        severity: String = "warning",
        message: String = "",
        lat: Double? = nil,
        lng: Double? = nil
    ) {
        self.type = type
        self.severity = severity
        self.message = message
        self.lat = lat
        self.lng = lng
    }
}

public enum JourneyLiveEvent: Sendable, Hashable {
    case snapshot(JourneyLiveSnapshotEntity)
    case location(JourneyLiveLocationEntity)
    case deviation(JourneyLiveDeviationEntity)
    case risk(JourneyLiveRiskEntity)
    case ended(JourneyLiveEndedEntity)
}
