//
//  GetJourneySharesUseCase.swift
//  Domain
//
//  Created by Dilshad Haidari on 18/10/26.
//

import Foundation

public final class GetJourneySharesUseCase: Sendable {
    private let repository: GuardianJourneyRepository

    public init(repository: GuardianJourneyRepository) {
        self.repository = repository
    }

    public func execute(guardianId: String) async throws -> [JourneyShareEntity] {
        return try await repository.getJourneyShares(guardianId: guardianId)
    }

    public func execute(journeyId: String) async throws -> [JourneyShareEntity] {
        return try await repository.getJourneyShares(guardianId: journeyId)
    }
}

public typealias GetGuardianJourneySharesUseCase = GetJourneySharesUseCase
