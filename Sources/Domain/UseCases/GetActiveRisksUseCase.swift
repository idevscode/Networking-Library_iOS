//
//  GetActiveRisksUseCase.swift
//  Domain
//
//  Created by SafeCircle Team.
//

import Foundation

public final class GetActiveRisksUseCase: Sendable {
    private let repository: RiskDetectionRepository

    public init(repository: RiskDetectionRepository) {
        self.repository = repository
    }

    public func execute() async throws -> [RiskEventEntity] {
        return try await repository.getActiveRisks()
    }
}
