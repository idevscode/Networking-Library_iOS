//
//  TrackJourneyUseCase.swift
//  Domain
//
//  Created by Dilshad Haidari on 25/10/26.
//

import Foundation

public final class TrackJourneyUseCase: Sendable {
    private let repository: JourneyRepository

    public init(repository: JourneyRepository) {
        self.repository = repository
    }

    public func execute(journeyId: String) async throws -> JourneyTrackEntity {
        return try await repository.trackJourney(journeyId: journeyId)
    }
}
