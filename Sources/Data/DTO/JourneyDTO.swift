//
//  JourneyDTO.swift
//  Networking-Library_iOS
//
//  Created by Dilshad Haidari on 26/09/26.
//

import Foundation
import Domain

// MARK: - RouteCoordinateDTO
struct RouteCoordinateDTO: Codable, Sendable {
    let lat: Double?
    let lng: Double?

    enum CodingKeys: String, CodingKey {
        case lat
        case lng
    }

    init(lat: Double?, lng: Double?) {
        self.lat = lat
        self.lng = lng
    }

    init(from decoder: Decoder) throws {
        if let container = try? decoder.container(keyedBy: CodingKeys.self) {
            if let dLat = try? container.decode(Double.self, forKey: .lat) {
                self.lat = dLat
            } else if let sLat = try? container.decode(String.self, forKey: .lat), let d = Double(sLat) {
                self.lat = d
            } else {
                self.lat = nil
            }

            if let dLng = try? container.decode(Double.self, forKey: .lng) {
                self.lng = dLng
            } else if let sLng = try? container.decode(String.self, forKey: .lng), let d = Double(sLng) {
                self.lng = d
            } else {
                self.lng = nil
            }
            return
        }

        if var arrContainer = try? decoder.unkeyedContainer() {
            if let first = try? arrContainer.decode(Double.self),
               let second = try? arrContainer.decode(Double.self) {
                self.lat = first
                self.lng = second
                return
            }
        }

        self.lat = nil
        self.lng = nil
    }

    func toEntity() -> RouteCoordinateEntity {
        RouteCoordinateEntity(
            lat: lat ?? 0.0,
            lng: lng ?? 0.0
        )
    }
}

// MARK: - JourneyDTO
struct JourneyDTO: Codable, Sendable {
    let id: String
    let userId: String?
    let startLabel: String?
    let startLat: Double?
    let startLng: Double?
    let endLabel: String?
    let endLat: Double?
    let endLng: Double?
    let plannedRoute: [RouteCoordinateDTO]?
    let plannedDistanceM: Double?
    let expectedDurationMinutes: Int?
    let status: String?
    let startedAt: String?
    let endedAt: String?
    let isDeviated: Bool?
    let deviationCount: Int?
    let lastDeviationAt: String?
    let maxDeviationM: Double?
    let lastPingAt: String?
    let pingCount: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case startLabel = "start_label"
        case startLat = "start_lat"
        case startLng = "start_lng"
        case endLabel = "end_label"
        case endLat = "end_lat"
        case endLng = "end_lng"
        case plannedRoute = "planned_route"
        case plannedDistanceM = "planned_distance_m"
        case expectedDurationMinutes = "expected_duration_minutes"
        case status
        case startedAt = "started_at"
        case endedAt = "ended_at"
        case isDeviated = "is_deviated"
        case deviationCount = "deviation_count"
        case lastDeviationAt = "last_deviation_at"
        case maxDeviationM = "max_deviation_m"
        case lastPingAt = "last_ping_at"
        case pingCount = "ping_count"
    }

    func toEntity() -> JourneyEntity {
        JourneyEntity(
            id: id,
            userId: userId ?? "",
            startLabel: startLabel ?? "",
            startLat: startLat ?? 0.0,
            startLng: startLng ?? 0.0,
            endLabel: endLabel ?? "",
            endLat: endLat ?? 0.0,
            endLng: endLng ?? 0.0,
            plannedRoute: plannedRoute?.map { $0.toEntity() } ?? [],
            plannedDistanceM: plannedDistanceM ?? 0.0,
            expectedDurationMinutes: expectedDurationMinutes ?? 0,
            status: status ?? "active",
            startedAt: startedAt ?? "",
            endedAt: endedAt,
            isDeviated: isDeviated ?? false,
            deviationCount: deviationCount ?? 0,
            lastDeviationAt: lastDeviationAt,
            maxDeviationM: maxDeviationM ?? 0.0,
            lastPingAt: lastPingAt,
            pingCount: pingCount ?? 0
        )
    }
}

// MARK: - JourneyShareDTO
struct JourneyShareDTO: Codable, Sendable {
    let guardianId: String
    let guardianName: String
    let shareToken: String
    let websocketUrl: String
    let expiresInHours: Int?

    enum CodingKeys: String, CodingKey {
        case guardianId = "guardian_id"
        case guardianName = "guardian_name"
        case shareToken = "share_token"
        case websocketUrl = "websocket_url"
        case expiresInHours = "expires_in_hours"
    }

    func toEntity() -> JourneyShareEntity {
        JourneyShareEntity(
            guardianId: guardianId,
            guardianName: guardianName,
            shareToken: shareToken,
            websocketUrl: websocketUrl,
            expiresInHours: expiresInHours ?? 0
        )
    }
}

// MARK: - StartJourneyResponseDTO (POST /api/v1/journeys)
nonisolated struct StartJourneyResponseDTO: Decodable, Sendable {
    let success: Bool
    let message: String
    let data: StartJourneyDataDTO

    struct StartJourneyDataDTO: Decodable, Sendable {
        let journey: JourneyDTO
        let shares: [JourneyShareDTO]?
    }

    func toEntity() -> StartJourneyResponseEntity {
        StartJourneyResponseEntity(
            success: success,
            message: message,
            journey: data.journey.toEntity(),
            shares: data.shares?.map { $0.toEntity() } ?? []
        )
    }
}

// MARK: - ActiveJourneyResponseDTO (GET /api/v1/journeys/active)
nonisolated struct ActiveJourneyResponseDTO: Decodable, Sendable {
    let success: Bool
    let message: String
    let data: JourneyDTO?

    func toEntity() -> JourneyEntity? {
        data?.toEntity()
    }
}

// MARK: - GetJourneyResponseDTO (GET /api/v1/journeys/{id} & POST /api/v1/journeys/{id}/stop)
nonisolated struct GetJourneyResponseDTO: Decodable, Sendable {
    let success: Bool
    let message: String
    let data: JourneyDTO

    func toEntity() -> JourneyEntity {
        data.toEntity()
    }
}

// MARK: - JourneyDeviationDTO
struct JourneyDeviationDTO: Codable, Sendable {
    let id: String?
    let journeyId: String?
    let lat: Double?
    let lng: Double?
    let accuracyM: Double?
    let speedMps: Double?
    let heading: Double?
    let batteryLevel: Int?
    let recordedAt: String?
    let receivedAt: String?
    let distanceFromRouteM: Double?
    let isDeviation: Bool?

    enum CodingKeys: String, CodingKey {
        case id
        case journeyId = "journey_id"
        case lat
        case lng
        case accuracyM = "accuracy_m"
        case speedMps = "speed_mps"
        case heading
        case batteryLevel = "battery_level"
        case recordedAt = "recorded_at"
        case receivedAt = "received_at"
        case distanceFromRouteM = "distance_from_route_m"
        case isDeviation = "is_deviation"
    }

    func toEntity() -> JourneyDeviationEntity {
        JourneyDeviationEntity(
            id: id ?? UUID().uuidString,
            journeyId: journeyId ?? "",
            lat: lat ?? 0.0,
            lng: lng ?? 0.0,
            accuracyM: accuracyM ?? 0.0,
            speedMps: speedMps ?? 0.0,
            heading: heading ?? 0.0,
            batteryLevel: batteryLevel ?? 100,
            recordedAt: recordedAt ?? "",
            receivedAt: receivedAt ?? "",
            distanceFromRouteM: distanceFromRouteM ?? 0.0,
            isDeviation: isDeviation ?? false
        )
    }
}

// MARK: - SendJourneyPingResponseDTO (POST /api/v1/journeys/{id}/pings)
nonisolated struct SendJourneyPingResponseDTO: Decodable, Sendable {
    let success: Bool
    let message: String
    let data: SendJourneyPingDataDTO?

    struct SendJourneyPingDataDTO: Decodable, Sendable {
        let accepted: Int?
        let rejected: Int?
        let journey: JourneyDTO?
        let deviations: [JourneyDeviationDTO]?
    }

    func toEntity() -> SendJourneyPingResponseEntity {
        SendJourneyPingResponseEntity(
            success: success,
            message: message,
            accepted: data?.accepted ?? 0,
            rejected: data?.rejected ?? 0,
            journey: data?.journey?.toEntity(),
            deviations: data?.deviations?.map { $0.toEntity() } ?? []
        )
    }
}

// MARK: - JourneyTrackPingDTO
struct JourneyTrackPingDTO: Codable, Sendable {
    let id: String?
    let journeyId: String?
    let lat: Double?
    let lng: Double?
    let accuracyM: Double?
    let speedMps: Double?
    let heading: Double?
    let batteryLevel: Int?
    let recordedAt: String?
    let receivedAt: String?
    let distanceFromRouteM: Double?
    let isDeviation: Bool?

    enum CodingKeys: String, CodingKey {
        case id
        case journeyId = "journey_id"
        case lat
        case lng
        case accuracyM = "accuracy_m"
        case speedMps = "speed_mps"
        case heading
        case batteryLevel = "battery_level"
        case recordedAt = "recorded_at"
        case receivedAt = "received_at"
        case distanceFromRouteM = "distance_from_route_m"
        case isDeviation = "is_deviation"
    }

    func toEntity() -> JourneyTrackPingEntity {
        JourneyTrackPingEntity(
            id: id ?? UUID().uuidString,
            journeyId: journeyId ?? "",
            lat: lat ?? 0.0,
            lng: lng ?? 0.0,
            accuracyM: accuracyM ?? 0.0,
            speedMps: speedMps ?? 0.0,
            heading: heading ?? 0.0,
            batteryLevel: batteryLevel ?? 100,
            recordedAt: recordedAt ?? "",
            receivedAt: receivedAt ?? "",
            distanceFromRouteM: distanceFromRouteM ?? 0.0,
            isDeviation: isDeviation ?? false
        )
    }
}

// MARK: - JourneyTrackResponseDTO (GET /api/v1/journeys/{id}/track)
nonisolated struct JourneyTrackResponseDTO: Decodable, Sendable {
    let success: Bool
    let message: String
    let data: JourneyTrackDataDTO?

    struct JourneyTrackDataDTO: Decodable, Sendable {
        let journey: JourneyDTO?
        let pings: [JourneyTrackPingDTO]?
    }

    func toEntity() -> JourneyTrackEntity? {
        guard let journey = data?.journey?.toEntity() else {
            return nil
        }
        return JourneyTrackEntity(
            journey: journey,
            pings: data?.pings?.map { $0.toEntity() } ?? []
        )
    }
}
