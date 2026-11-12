//
//  InvitationResponse.swift
//  Networking-Library_iOS
//
//  Created by Dilshad Haidari on 13/10/26.
//


import Foundation
import Domain

struct InvitationResponse: Codable {
    let data: [Invitation]
    let message: String
    let meta: InvitationMeta?
    let success: Bool
    
    func requesterListEntity() -> [GuardianRequesterEntity] {
        return data.map { model in
            GuardianRequesterEntity(
                id: model.id,
                requesterId: model.requester.id,
                fullName: model.requester.fullName,
                email: model.requester.email ?? "",
                phone: model.requester.phone ?? "",
                relationship: model.relationshipLabel ?? "",
                status: model.status
            )
        }
    }
}

struct Invitation: Codable, Identifiable {
    let id: String
    let invitedAt: String?
    let relationshipLabel: String?
    let requester: InvitationRequester
    let status: String

    enum CodingKeys: String, CodingKey {
        case id
        case invitedAt = "invited_at"
        case relationshipLabel = "relationship_label"
        case requester
        case status
    }
}

struct InvitationRequester: Codable {
    let email: String?
    let fullName: String
    let id: String
    let phone: String?

    enum CodingKeys: String, CodingKey {
        case email
        case fullName = "full_name"
        case id
        case phone
    }
}

struct InvitationMeta: Codable {
    let count: Int?
}
