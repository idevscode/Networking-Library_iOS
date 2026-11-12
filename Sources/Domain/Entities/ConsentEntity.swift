//
//  ConsentEntity.swift
//  Domain
//
//  Created by Dilshad Haidari on 29/09/26.
//

import Foundation

// MARK: - Enums

public enum ConsentSubjectType: String, Codable, Sendable, CaseIterable {
    case guardian
    case org
    case app
}

public enum ConsentScope: String, Codable, Sendable, CaseIterable {
    case location
    case journey
    case sos
    case evidence
}

public enum ConsentLevel: String, Codable, Sendable, CaseIterable {
    case always
    case journeyOnly = "journey_only"
    case sosOnly = "sos_only"
}

public struct ConsentEntity: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public let subjectType: String
    public let subjectId: String
    public let scope: String
    public let level: String
    public let grantedAt: String
    public let revokedAt: String?

    public init(
        id: String,
        subjectType: String,
        subjectId: String,
        scope: String,
        level: String,
        grantedAt: String,
        revokedAt: String? = nil
    ) {
        self.id = id
        self.subjectType = subjectType
        self.subjectId = subjectId
        self.scope = scope
        self.level = level
        self.grantedAt = grantedAt
        self.revokedAt = revokedAt
    }
}

