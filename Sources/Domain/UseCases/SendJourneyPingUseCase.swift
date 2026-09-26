//
//  SendJourneyPingUseCase.swift
//  Domain
//
//  Created by Dilshad Haidari on 26/09/26.
//

import Foundation

public final class SendJourneyPingUseCase: Sendable {
    private let repository: JourneyRepository

    public init(repository: JourneyRepository) {
        self.repository = repository
    }

    public func execute(
        journeyId: String,
        lat: Double,
        lng: Double,
        isDeviated: Bool? = nil,
        deviationDistanceM: Double? = nil
    ) async throws {
        try await repository.sendLocationPing(
            journeyId: journeyId,
            lat: lat,
            lng: lng,
            isDeviated: isDeviated,
            deviationDistanceM: deviationDistanceM
        )
    }
}
