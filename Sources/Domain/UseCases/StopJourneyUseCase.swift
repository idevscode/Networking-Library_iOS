//
//  StopJourneyUseCase.swift
//  Domain
//
//  Created by Dilshad Haidari on 26/09/26.
//

import Foundation

public final class StopJourneyUseCase: Sendable {
    private let repository: JourneyRepository

    public init(repository: JourneyRepository) {
        self.repository = repository
    }

    public func execute(journeyId: String) async throws -> JourneyEntity {
        return try await repository.stopJourney(id: journeyId)
    }
}
