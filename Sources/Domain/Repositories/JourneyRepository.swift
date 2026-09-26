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

    /// Stop/end an active journey
    func stopJourney(id: String) async throws -> JourneyEntity

    /// Report periodic GPS location ping with optional deviation metadata
    func sendLocationPing(
        journeyId: String,
        lat: Double,
        lng: Double,
        isDeviated: Bool?,
        deviationDistanceM: Double?
    ) async throws
}
