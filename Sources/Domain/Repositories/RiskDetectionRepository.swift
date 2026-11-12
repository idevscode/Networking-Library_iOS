//
//  RiskDetectionRepository.swift
//  Domain
//
//  Created by SafeCircle Team.
//

import Foundation

public protocol RiskDetectionRepository: Sendable {
    /// Home-screen banners: open alerts on my live journey
    func getActiveRisks() async throws -> [RiskEventEntity]

    /// All risk events on one journey (optionally filtered by "open" or "resolved")
    func getJourneyRisks(journeyId: String, status: String?) async throws -> [RiskEventEntity]

    /// Dismiss an alert: "user_safe" or "false_alarm", with optional note
    func resolveRisk(eventId: String, resolution: String, note: String?) async throws -> RiskEventEntity
}

public extension RiskDetectionRepository {
    func getJourneyRisks(journeyId: String) async throws -> [RiskEventEntity] {
        try await getJourneyRisks(journeyId: journeyId, status: nil)
    }

    func resolveRisk(eventId: String, resolution: String) async throws -> RiskEventEntity {
        try await resolveRisk(eventId: eventId, resolution: resolution, note: nil)
    }
}
