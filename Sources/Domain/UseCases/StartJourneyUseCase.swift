//
//  StartJourneyUseCase.swift
//  Domain
//
//  Created by Dilshad Haidari on 26/09/26.
//

import Foundation

public final class StartJourneyUseCase: Sendable {
    private let repository: JourneyRepository

    public init(repository: JourneyRepository) {
        self.repository = repository
    }

    public func execute(
        start: JourneyWaypointEntity,
        end: JourneyWaypointEntity,
        plannedRoute: [RouteCoordinateEntity],
        expectedDurationMinutes: Int
    ) async throws -> StartJourneyResponseEntity {
        return try await repository.startJourney(
            start: start,
            end: end,
            plannedRoute: plannedRoute,
            expectedDurationMinutes: expectedDurationMinutes
        )
    }
}
