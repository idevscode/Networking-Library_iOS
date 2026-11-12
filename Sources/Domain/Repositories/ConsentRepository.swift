//
//  ConsentRepository.swift
//  Domain
//
//  Created by Dilshad Haidari on 29/09/26.
//

import Foundation

public protocol ConsentRepository: Sendable {
    /// Grant consent for a guardian/org/app before starting a journey
    func grantConsent(
        subjectType: String,
        subjectId: String,
        scope: String,
        level: String
    ) async throws -> ConsentEntity
}
