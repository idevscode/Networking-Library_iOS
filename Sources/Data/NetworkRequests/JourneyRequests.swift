//
//  JourneyRequests.swift
//  Networking-Library_iOS
//
//  Created by Dilshad Haidari on 26/09/26.
//

import Foundation
import Domain

// MARK: - StartJourneyRequest (POST api/v1/journeys)
struct StartJourneyRequest: RequestProtocol, Sendable {
    let start: JourneyWaypointEntity
    let end: JourneyWaypointEntity
    let plannedRoute: [RouteCoordinateEntity]
    let expectedDurationMinutes: Int

    var path: String {
        "api/v1/journeys"
    }

    var methodType: HTTPMethodType {
        .POST
    }

    var parameters: [String: Any]? {
        let routeArray: [[String: Any]] = plannedRoute.map { coord in
            [
                "lat": coord.lat,
                "lng": coord.lng
            ]
        }

        let body: [String: Any] = [
            "start": [
                "lat": start.lat,
                "lng": start.lng,
                "label": start.label
            ],
            "end": [
                "lat": end.lat,
                "lng": end.lng,
                "label": end.label
            ],
            "planned_route": routeArray,
            "expected_duration_minutes": expectedDurationMinutes
        ]

        return body
    }
}

// MARK: - GetActiveJourneyRequest (GET api/v1/journeys/active)
struct GetActiveJourneyRequest: RequestProtocol, Sendable {
    var path: String {
        "api/v1/journeys/active"
    }

    var methodType: HTTPMethodType {
        .GET
    }

    var parameters: [String: Any]? {
        nil
    }
}

// MARK: - GetJourneyRequest (GET api/v1/journeys/{id})
struct GetJourneyRequest: RequestProtocol, Sendable {
    let journeyId: String

    var path: String {
        "api/v1/journeys/\(journeyId)"
    }

    var methodType: HTTPMethodType {
        .GET
    }

    var parameters: [String: Any]? {
        nil
    }
}

// MARK: - StopJourneyRequest (POST api/v1/journeys/{id}/stop)
struct StopJourneyRequest: RequestProtocol, Sendable {
    let journeyId: String
    let status: String
    let finalPing: JourneyPingItemEntity?

    init(
        journeyId: String,
        status: String = "completed",
        finalPing: JourneyPingItemEntity? = nil
    ) {
        self.journeyId = journeyId
        self.status = status
        self.finalPing = finalPing
    }

    var path: String {
        "api/v1/journeys/\(journeyId)/stop"
    }

    var methodType: HTTPMethodType {
        .POST
    }

    var parameters: [String: Any]? {
        var body: [String: Any] = [
            "status": status
        ]
        if let ping = finalPing {
            body["final_ping"] = [
                "lat": ping.lat,
                "lng": ping.lng,
                "accuracy_m": ping.accuracyM,
                "speed_mps": ping.speedMps,
                "heading": ping.heading,
                "battery_level": ping.batteryLevel,
                "recorded_at": ping.recordedAt
            ]
        }
        return body
    }
}

// MARK: - SendJourneyPingRequest (POST api/v1/journeys/{id}/pings)
struct SendJourneyPingRequest: RequestProtocol, Sendable {
    let journeyId: String
    let pings: [JourneyPingItemEntity]

    var path: String {
        "api/v1/journeys/\(journeyId)/pings"
    }

    var methodType: HTTPMethodType {
        .POST
    }

    var parameters: [String: Any]? {
        let pingList: [[String: Any]] = pings.map { ping in
            [
                "lat": ping.lat,
                "lng": ping.lng,
                "accuracy_m": ping.accuracyM,
                "speed_mps": ping.speedMps,
                "heading": ping.heading,
                "battery_level": ping.batteryLevel,
                "recorded_at": ping.recordedAt
            ]
        }
        return [
            "pings": pingList
        ]
    }
}

// MARK: - TrackJourneyRequest (GET api/v1/journeys/{id}/track)
struct TrackJourneyRequest: RequestProtocol, Sendable {
    let journeyId: String

    var path: String {
        "api/v1/journeys/\(journeyId)/track"
    }

    var methodType: HTTPMethodType {
        .GET
    }

    var parameters: [String: Any]? {
        nil
    }
}
