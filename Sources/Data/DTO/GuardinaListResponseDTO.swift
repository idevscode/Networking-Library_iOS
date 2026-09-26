
//
//  UserResponse.swift
//  Networking-Library_iOS
//
//  Created by Dilshad Haidari on 04/09/26.
//


// MARK: - UserResponse
import Domain

struct GuardianListResponseDTO: Decodable, Sendable {
    let success: Bool
    let message: String
    let data: [Guardian]
    let meta, errors: Errors
    
    func guardianListEntity() -> [GuardianEntity] {
        return data.map { value in
            GuardianEntity(id: value.id, fullName: value.fullName, email: value.email, phone: value.phone, relationship: value.relationshipLabel, status: value.status)
        }
    }
}

// MARK: - Datum
struct Guardian: Decodable, Sendable {
    let id, fullName, email, phone: String
    let relationshipLabel, status, invitedAt, createdAt: String
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
        case email, phone
        case relationshipLabel = "relationship_label"
        case status
        case invitedAt = "invited_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    func toEntity() -> GuardianEntity {
        return GuardianEntity(
            id: id,
            fullName: fullName,
            email: email,
            phone: phone,
            relationship: relationshipLabel,
            status: status
        )
    }
    
}
