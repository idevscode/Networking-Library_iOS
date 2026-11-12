//
//  RiskEventDTO.swift
//  Data
//
//  Created by SafeCircle Team.
//

import Foundation
import Domain

// MARK: - Helper for decoding flexible JSON dictionary values to String
struct FlexibleJSONValue: Decodable, Sendable {
    let stringValue: String

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let str = try? container.decode(String.self) {
            stringValue = str
        } else if let intVal = try? container.decode(Int.self) {
            stringValue = String(intVal)
        } else if let dblVal = try? container.decode(Double.self) {
            stringValue = String(dblVal)
        } else if let boolVal = try? container.decode(Bool.self) {
            stringValue = String(boolVal)
        } else {
            stringValue = ""
        }
    }
}

// MARK: - RiskEventDTO (matches RiskEventOut)
struct RiskEventDTO: Decodable, Sendable {
    let id: String
    let journeyId: String?
    let userId: String?
    let type: String?
    let severity: String?
    let status: String?
    let message: String?
    let detectedAt: String?
    let resolvedAt: String?
    let resolution: String?
    let resolvedBy: String?
    let lat: Double?
    let lng: Double?
    let details: [String: FlexibleJSONValue]?
    let acknowledgedAt: String?
    let acknowledgedBy: String?

    enum CodingKeys: String, CodingKey {
        case id
        case journeyId = "journey_id"
        case userId = "user_id"
        case type
        case severity
        case status
        case message
        case detectedAt = "detected_at"
        case resolvedAt = "resolved_at"
        case resolution
        case resolvedBy = "resolved_by"
        case lat
        case lng
        case details
        case acknowledgedAt = "acknowledged_at"
        case acknowledgedBy = "acknowledged_by"
    }

    func toEntity() -> RiskEventEntity {
        let eventType = RiskEventType(rawValue: type ?? "") ?? .unknown
        let eventSeverity = RiskSeverity(rawValue: (severity ?? "").lowercased()) ?? .unknown
        let eventStatus = RiskStatus(rawValue: (status ?? "").lowercased()) ?? .unknown

        let stringDetails = details?.mapValues { $0.stringValue }

        return RiskEventEntity(
            id: id,
            journeyId: journeyId ?? "",
            userId: userId ?? "",
            type: eventType,
            severity: eventSeverity,
            status: eventStatus,
            message: message ?? "",
            detectedAt: detectedAt ?? "",
            resolvedAt: resolvedAt,
            resolution: resolution,
            resolvedBy: resolvedBy,
            lat: lat,
            lng: lng,
            details: stringDetails,
            acknowledgedAt: acknowledgedAt,
            acknowledgedBy: acknowledgedBy
        )
    }
}

// MARK: - Single Risk Event Response DTO
struct RiskEventResponseDTO: Decodable, Sendable {
    let success: Bool
    let message: String
    let data: RiskEventDTO?

    func toEntity() -> RiskEventEntity? {
        data?.toEntity()
    }
}

// MARK: - List of Risk Events Response DTO
struct RiskEventListResponseDTO: Decodable, Sendable {
    let success: Bool
    let message: String
    let data: [RiskEventDTO]?

    func toEntities() -> [RiskEventEntity] {
        data?.map { $0.toEntity() } ?? []
    }
}
