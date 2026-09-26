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

    var path: String {
        "api/v1/journeys/\(journeyId)/stop"
    }

    var methodType: HTTPMethodType {
        .POST
    }

    var parameters: [String: Any]? {
        [:]
    }
}

// MARK: - SendJourneyPingRequest (POST api/v1/journeys/{id}/pings)
struct SendJourneyPingRequest: RequestProtocol, Sendable {
    let journeyId: String
    let lat: Double
    let lng: Double
    let isDeviated: Bool?
    let deviationDistanceM: Double?

    var path: String {
        "api/v1/journeys/\(journeyId)/pings"
    }

    var methodType: HTTPMethodType {
        .POST
    }

    var parameters: [String: Any]? {
        var body: [String: Any] = [
            "lat": lat,
            "lng": lng
        ]
        if let isDeviated = isDeviated {
            body["is_deviated"] = isDeviated
        }
        if let deviationDistanceM = deviationDistanceM {
            body["deviation_distance_m"] = deviationDistanceM
        }
        return body
    }
}
