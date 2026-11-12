//
//  ResolveRiskUseCase.swift
//  Domain
//
//  Created by SafeCircle Team.
//

import Foundation

public final class ResolveRiskUseCase: Sendable {
    private let repository: RiskDetectionRepository

    public init(repository: RiskDetectionRepository) {
        self.repository = repository
    }

    public func execute(eventId: String, resolution: String = "user_safe", note: String? = nil) async throws -> RiskEventEntity {
        return try await repository.resolveRisk(eventId: eventId, resolution: resolution, note: note)
    }
}
