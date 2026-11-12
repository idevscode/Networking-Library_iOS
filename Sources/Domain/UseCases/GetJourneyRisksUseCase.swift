//
//  GetJourneyRisksUseCase.swift
//  Domain
//
//  Created by SafeCircle Team.
//

import Foundation

public final class GetJourneyRisksUseCase: Sendable {
    private let repository: RiskDetectionRepository

    public init(repository: RiskDetectionRepository) {
        self.repository = repository
    }

    public func execute(journeyId: String, status: String? = nil) async throws -> [RiskEventEntity] {
        return try await repository.getJourneyRisks(journeyId: journeyId, status: status)
    }
}
