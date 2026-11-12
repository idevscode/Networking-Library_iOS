//
//  RiskEventEntity.swift
//  Domain
//
//  Created by SafeCircle Team.
//

import Foundation

public enum RiskEventType: String, Codable, Sendable, Hashable, CaseIterable {
    case routeDeviation = "route_deviation"
    case unusualStop = "unusual_stop"
    case noMovement = "no_movement"
    case gpsSignalLoss = "gps_signal_loss"
    case lowBattery = "low_battery"
    case missedCheckIn = "missed_check_in"
    case helpRequested = "help_requested"
    case unknown

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let raw = try container.decode(String.self)
        self = RiskEventType(rawValue: raw) ?? .unknown
    }

    public var displayName: String {
        switch self {
        case .routeDeviation: return "Route Deviation"
        case .unusualStop: return "Unusual Stop"
        case .noMovement: return "No Movement"
        case .gpsSignalLoss: return "GPS Signal Loss"
        case .lowBattery: return "Low Battery"
        case .missedCheckIn: return "Missed Check-In"
        case .helpRequested: return "Help Requested"
        case .unknown: return "Alert"
        }
    }
}

public enum RiskSeverity: String, Codable, Sendable, Hashable, CaseIterable {
    case low
    case medium
    case high
    case critical
    case unknown

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let raw = try container.decode(String.self)
        self = RiskSeverity(rawValue: raw.lowercased()) ?? .unknown
    }
}

public enum RiskStatus: String, Codable, Sendable, Hashable, CaseIterable {
    case open
    case resolved
    case unknown

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let raw = try container.decode(String.self)
        self = RiskStatus(rawValue: raw.lowercased()) ?? .unknown
    }
}

public enum RiskResolutionType: String, Codable, Sendable, Hashable, CaseIterable {
    case userSafe = "user_safe"
    case falseAlarm = "false_alarm"
}

public struct RiskEventEntity: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public let journeyId: String
    public let userId: String
    public let type: RiskEventType
    public let severity: RiskSeverity
    public let status: RiskStatus
    public let message: String
    public let detectedAt: String
    public let resolvedAt: String?
    public let resolution: String?
    public let resolvedBy: String?
    public let lat: Double?
    public let lng: Double?
    public let details: [String: String]?
    public let acknowledgedAt: String?
    public let acknowledgedBy: String?

    public init(
        id: String,
        journeyId: String,
        userId: String,
        type: RiskEventType,
        severity: RiskSeverity,
        status: RiskStatus,
        message: String,
        detectedAt: String,
        resolvedAt: String? = nil,
        resolution: String? = nil,
        resolvedBy: String? = nil,
        lat: Double? = nil,
        lng: Double? = nil,
        details: [String: String]? = nil,
        acknowledgedAt: String? = nil,
        acknowledgedBy: String? = nil
    ) {
        self.id = id
        self.journeyId = journeyId
        self.userId = userId
        self.type = type
        self.severity = severity
        self.status = status
        self.message = message
        self.detectedAt = detectedAt
        self.resolvedAt = resolvedAt
        self.resolution = resolution
        self.resolvedBy = resolvedBy
        self.lat = lat
        self.lng = lng
        self.details = details
        self.acknowledgedAt = acknowledgedAt
        self.acknowledgedBy = acknowledgedBy
    }
}
