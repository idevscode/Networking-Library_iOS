//
//  ConsentDTO.swift
//  Networking-Library_iOS
//
//  Created by Dilshad Haidari on 29/09/26.
//

import Foundation
import Domain

// MARK: - ConsentDTO
struct ConsentDTO: Codable, Sendable {
    let id: String?
    let subjectType: String?
    let subjectId: String?
    let scope: String?
    let level: String?
    let grantedAt: String?
    let revokedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case subjectType = "subject_type"
        case subjectId = "subject_id"
        case scope
        case level
        case grantedAt = "granted_at"
        case revokedAt = "revoked_at"
    }

    func toEntity() -> ConsentEntity {
        ConsentEntity(
            id: id ?? "",
            subjectType: subjectType ?? "",
            subjectId: subjectId ?? "",
            scope: scope ?? "",
            level: level ?? "",
            grantedAt: grantedAt ?? "",
            revokedAt: revokedAt
        )
    }
}

// MARK: - GrantConsentResponseDTO (POST /api/v1/consent/grant)
nonisolated struct GrantConsentResponseDTO: Decodable, Sendable {
    let success: Bool
    let message: String
    let data: ConsentDTO

    func toEntity() -> ConsentEntity {
        data.toEntity()
    }
}
