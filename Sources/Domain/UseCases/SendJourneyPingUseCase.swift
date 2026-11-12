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
        pings: [JourneyPingItemEntity]
    ) async throws -> SendJourneyPingResponseEntity {
        return try await repository.sendLocationPing(
            journeyId: journeyId,
            pings: pings
        )
    }

    @discardableResult
    public func execute(
        journeyId: String,
        lat: Double,
        lng: Double,
        accuracyM: Double = 5.0,
        speedMps: Double = 0.0,
        heading: Double = 0.0,
        batteryLevel: Int = 100,
        recordedAt: String? = nil,
        isDeviated: Bool? = nil,
        deviationDistanceM: Double? = nil
    ) async throws -> SendJourneyPingResponseEntity {
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

        return try await repository.sendLocationPing(
            journeyId: journeyId,
            pings: [ping]
        )
    }
}
