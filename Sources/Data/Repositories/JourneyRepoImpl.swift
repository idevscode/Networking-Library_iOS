//
//  JourneyRepoImpl.swift
//  Networking-Library_iOS
//
//  Created by Dilshad Haidari on 26/09/26.
//

import Foundation
import Domain

final class JourneyRepoImpl: JourneyRepository {

    private let networkClient: NetworkClient

    init(networkClient: NetworkClient = NetworkExecutor1()) {
        self.networkClient = networkClient
    }

    func startJourney(
        start: JourneyWaypointEntity,
        end: JourneyWaypointEntity,
        plannedRoute: [RouteCoordinateEntity],
        expectedDurationMinutes: Int
    ) async throws -> StartJourneyResponseEntity {
        let request = StartJourneyRequest(
            start: start,
            end: end,
            plannedRoute: plannedRoute,
            expectedDurationMinutes: expectedDurationMinutes
        )
        let response: StartJourneyResponseDTO = try await networkClient.execute(request)
        return response.toEntity()
    }

    func getActiveJourney() async throws -> JourneyEntity? {
        let request = GetActiveJourneyRequest()
        let response: ActiveJourneyResponseDTO = try await networkClient.execute(request)
        return response.toEntity()
    }

    func getJourney(id: String) async throws -> JourneyEntity {
        let request = GetJourneyRequest(journeyId: id)
        let response: GetJourneyResponseDTO = try await networkClient.execute(request)
        return response.toEntity()
    }

    func stopJourney(id: String) async throws -> JourneyEntity {
        let request = StopJourneyRequest(journeyId: id)
        let response: GetJourneyResponseDTO = try await networkClient.execute(request)
        return response.toEntity()
    }

    func sendLocationPing(
        journeyId: String,
        lat: Double,
        lng: Double,
        isDeviated: Bool?,
        deviationDistanceM: Double?
    ) async throws {
        let request = SendJourneyPingRequest(
            journeyId: journeyId,
            lat: lat,
            lng: lng,
            isDeviated: isDeviated,
            deviationDistanceM: deviationDistanceM
        )
        let _: DefaultResponseDTO = try await networkClient.execute(request)
    }
}
