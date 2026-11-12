//
//  GuardianJourneyRepository.swift
//  Domain
//
//  Created by Dilshad Haidari on 18/10/26.
//

import Foundation

public protocol GuardianJourneyRepository: Sendable {
    /// Fetch journey shares for a given journey ID
    func getJourneyShares(guardianId: String) async throws -> [JourneyShareEntity]
}

public extension GuardianJourneyRepository {
    func getShares(journeyId: String) async throws -> [JourneyShareEntity] {
        try await getJourneyShares(guardianId: journeyId)
    }
}
