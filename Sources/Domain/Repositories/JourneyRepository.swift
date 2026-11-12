//
//  JourneyRepository.swift
//  Domain
//
//  Created by Dilshad Haidari on 26/09/26.
//

import Foundation

public protocol JourneyRepository: Sendable {
    /// Start a new journey with source, destination, planned route waypoints, and expected duration
    func startJourney(
        start: JourneyWaypointEntity,
        end: JourneyWaypointEntity,
        plannedRoute: [RouteCoordinateEntity],
        expectedDurationMinutes: Int
    ) async throws -> StartJourneyResponseEntity

    /// Fetch current active journey (if any)
    func getActiveJourney() async throws -> JourneyEntity?

    /// Fetch a single journey by ID
    func getJourney(id: String) async throws -> JourneyEntity

    /// Stop/end an active journey with status and optional final ping
    func stopJourney(
        id: String,
        status: String,
        finalPing: JourneyPingItemEntity?
    ) async throws -> JourneyEntity

    /// Stop/end an active journey (convenience)
    func stopJourney(id: String) async throws -> JourneyEntity

    /// Report periodic GPS location pings to backend
    func sendLocationPing(
        journeyId: String,
        pings: [JourneyPingItemEntity]
    ) async throws -> SendJourneyPingResponseEntity

    /// Send device heartbeat status
    func sendDeviceStatus(journeyId: String, status: DeviceStatusEntity) async throws

    /// Track a journey with full route geometry, metadata, and ping history
    func trackJourney(journeyId: String) async throws -> JourneyTrackEntity
}

public extension JourneyRepository {
    func stopJourney(id: String) async throws -> JourneyEntity {
        try await stopJourney(id: id, status: "completed", finalPing: nil)
    }
}

