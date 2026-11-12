//
//  GrantConsentUseCase.swift
//  Domain
//
//  Created by Dilshad Haidari on 29/09/26.
//

import Foundation

public final class GrantConsentUseCase: Sendable {
    private let repository: ConsentRepository

    public init(repository: ConsentRepository) {
        self.repository = repository
    }

    public func execute(
        subjectType: ConsentSubjectType = .guardian,
        subjectId: String,
        scope: ConsentScope = .journey,
        level: ConsentLevel = .journeyOnly
    ) async throws -> ConsentEntity {
        return try await repository.grantConsent(
            subjectType: subjectType.rawValue,
            subjectId: subjectId,
            scope: scope.rawValue,
            level: level.rawValue
        )
    }

    public func execute(
        subjectType: String,
        subjectId: String,
        scope: String,
        level: String
    ) async throws -> ConsentEntity {
        return try await repository.grantConsent(
            subjectType: subjectType,
            subjectId: subjectId,
            scope: scope,
            level: level
        )
    }
}
