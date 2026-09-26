//
//  AddGuardianResponseDTO.swift
//  Networking-Library_iOS
//
//  Created by Dilshad Haidari on 14/09/26.
//

import Foundation
import Domain

struct AddGuardianResponseDTO: Decodable, Sendable {
    let success: Bool
    let message: String
    let data: AddGuardianDataDTO
    
    func toEntity() -> GuardianEntity {
        data.toEntity()
    }
}

struct AddGuardianDataDTO: Decodable, Sendable {
    let id: String
    let fullName: String
    let email: String
    let phone: String?
    let relationshipLabel: String?
    let status: String
    let invitedAt: String?
    let createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
        case email
        case phone
        case relationshipLabel = "relationship_label"
        case status
        case invitedAt = "invited_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }

    func toEntity() -> GuardianEntity {
        GuardianEntity(
            id: id,
            fullName: fullName,
            email: email,
            phone: phone ?? "",
            relationship: relationshipLabel ?? "",
            status: status
        )
    }
}
