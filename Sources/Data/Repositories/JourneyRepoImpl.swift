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
        do {
            let response: ActiveJourneyResponseDTO = try await networkClient.execute(request)
            return response.toEntity()
        } catch let NetworkError.httpError(statusCode, _) where statusCode == 404 {
            return nil
        }
    }

    func getJourney(id: String) async throws -> JourneyEntity {
        let request = GetJourneyRequest(journeyId: id)
        let response: GetJourneyResponseDTO = try await networkClient.execute(request)
        return response.toEntity()
    }

    func stopJourney(
        id: String,
        status: String = "completed",
        finalPing: JourneyPingItemEntity? = nil
    ) async throws -> JourneyEntity {
        let request = StopJourneyRequest(
            journeyId: id,
            status: status,
            finalPing: finalPing
        )
        let response: GetJourneyResponseDTO = try await networkClient.execute(request)
        return response.toEntity()
    }

    func sendLocationPing(
        journeyId: String,
        pings: [JourneyPingItemEntity]
    ) async throws -> SendJourneyPingResponseEntity {
        let request = SendJourneyPingRequest(
            journeyId: journeyId,
            pings: pings
        )
        let response: SendJourneyPingResponseDTO = try await networkClient.execute(request)
        return response.toEntity()
    }

    func sendDeviceStatus(journeyId: String, status: DeviceStatusEntity) async throws {
        let request = DeviceStatusRequest(journeyId: journeyId, status: status)
        do {
            let _: DeviceStatusResponseDTO = try await networkClient.execute(request)
        } catch {
            // Silently swallow HTTP errors (heartbeat is fire-and-forget)
        }
    }

    func trackJourney(journeyId: String) async throws -> JourneyTrackEntity {
        let request = TrackJourneyRequest(journeyId: journeyId)
        let response: JourneyTrackResponseDTO = try await networkClient.execute(request)
        guard let entity = response.toEntity() else {
            throw NetworkError.decodingFailed
        }
        return entity
    }
}

