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

    public func execute(
        journeyId: String,
        status: String = "completed",
        finalPing: JourneyPingItemEntity? = nil
    ) async throws -> JourneyEntity {
        return try await repository.stopJourney(
            id: journeyId,
            status: status,
            finalPing: finalPing
        )
    }

    @discardableResult
    public func execute(
        journeyId: String,
        status: String = "completed",
        lat: Double,
        lng: Double,
        accuracyM: Double = 5.0,
        speedMps: Double = 0.0,
        heading: Double = 0.0,
        batteryLevel: Int = 100,
        recordedAt: String? = nil
    ) async throws -> JourneyEntity {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let timestamp = recordedAt ?? formatter.string(from: Date())

        let ping = JourneyPingItemEntity(
            lat: lat,
            lng: lng,
            accuracyM: accuracyM,
            speedMps: speedMps,
            heading: heading,
            batteryLevel: batteryLevel,
            recordedAt: timestamp
        )

        return try await repository.stopJourney(
            id: journeyId,
            status: status,
            finalPing: ping
        )
    }
}
