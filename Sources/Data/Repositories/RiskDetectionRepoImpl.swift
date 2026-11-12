//
//  RiskDetectionRepoImpl.swift
//  Data
//
//  Created by SafeCircle Team.
//

import Foundation
import Domain

final class RiskDetectionRepoImpl: RiskDetectionRepository {
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient = NetworkExecutor1()) {
        self.networkClient = networkClient
    }

    func getActiveRisks() async throws -> [RiskEventEntity] {
        let request = GetActiveRisksRequest()
        do {
            let response: RiskEventListResponseDTO = try await networkClient.execute(request)
            return response.toEntities()
        } catch let NetworkError.httpError(statusCode, _) where statusCode == 404 {
            return []
        }
    }

    func getJourneyRisks(journeyId: String, status: String?) async throws -> [RiskEventEntity] {
        let request = GetJourneyRisksRequest(journeyId: journeyId, status: status)
        do {
            let response: RiskEventListResponseDTO = try await networkClient.execute(request)
            return response.toEntities()
        } catch let NetworkError.httpError(statusCode, _) where statusCode == 404 {
            return []
        }
    }

    func resolveRisk(eventId: String, resolution: String, note: String?) async throws -> RiskEventEntity {
        let request = ResolveRiskRequest(eventId: eventId, resolution: resolution, note: note)
        let response: RiskEventResponseDTO = try await networkClient.execute(request)
        guard let entity = response.toEntity() else {
            throw NetworkError.decodingFailed
        }
        return entity
    }
}
