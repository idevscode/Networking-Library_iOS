//
//  RiskDetectionRequests.swift
//  Data
//
//  Created by SafeCircle Team.
//

import Foundation
import Domain

// MARK: - GetActiveRisksRequest (GET api/v1/risk-events/active)
struct GetActiveRisksRequest: RequestProtocol, Sendable {
    var path: String {
        "api/v1/risk-events/active"
    }

    var methodType: HTTPMethodType {
        .GET
    }

    var parameters: [String: Any]? {
        nil
    }
}

// MARK: - GetJourneyRisksRequest (GET api/v1/journeys/{journey_id}/risk-events)
struct GetJourneyRisksRequest: RequestProtocol, Sendable {
    let journeyId: String
    let status: String?

    init(journeyId: String, status: String? = nil) {
        self.journeyId = journeyId
        self.status = status
    }

    var path: String {
        if let status = status, !status.isEmpty {
            return "api/v1/journeys/\(journeyId)/risk-events?status=\(status)"
        }
        return "api/v1/journeys/\(journeyId)/risk-events"
    }

    var methodType: HTTPMethodType {
        .GET
    }

    var parameters: [String: Any]? {
        nil
    }
}

// MARK: - ResolveRiskRequest (POST api/v1/risk-events/{event_id}/resolve)
struct ResolveRiskRequest: RequestProtocol, Sendable {
    let eventId: String
    let resolution: String
    let note: String?

    init(eventId: String, resolution: String = "user_safe", note: String? = nil) {
        self.eventId = eventId
        self.resolution = resolution
        self.note = note
    }

    var path: String {
        "api/v1/risk-events/\(eventId)/resolve"
    }

    var methodType: HTTPMethodType {
        .POST
    }

    var parameters: [String: Any]? {
        var body: [String: Any] = [
            "resolution": resolution
        ]
        if let note = note {
            body["note"] = note
        }
        return body
    }
}

// MARK: - GetGuardianRiskEventsRequest (GET api/v1/guardian/me/risk-events)
struct GetGuardianRiskEventsRequest: RequestProtocol, Sendable {
    var path: String {
        "api/v1/guardian/me/risk-events"
    }

    var methodType: HTTPMethodType {
        .GET
    }

    var parameters: [String: Any]? {
        nil
    }
}

// MARK: - AcknowledgeRiskEventRequest (POST api/v1/guardian/me/risk-events/{event_id}/acknowledge)
struct AcknowledgeRiskEventRequest: RequestProtocol, Sendable {
    let eventId: String

    var path: String {
        "api/v1/guardian/me/risk-events/\(eventId)/acknowledge"
    }

    var methodType: HTTPMethodType {
        .POST
    }

    var parameters: [String: Any]? {
        nil
    }
}
