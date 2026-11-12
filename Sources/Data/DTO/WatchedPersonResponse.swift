//
//  File.swift
//  Networking-Library_iOS
//
//  Created by Dilshad Haidari on 15/10/26.
//

import Foundation
import Domain


struct WatchingPersonResponse: Decodable, Sendable {
    let success: Bool
    let message: String
    let data: [WatchingPerson]
    let meta: Meta
//    let errors: Errors
    
    func toEntity() -> [WatchingPersonEntity] {
        data.map { model in
            WatchingPersonEntity(
                guardianId: model.guardianId,
                userId: model.userId,
                fullName: model.fullName,
                phone: model.phone,
                relationshipLabel: model.relationshipLabel,
                accessLevel: model.accessLevel,
                hasActiveJourney: model.hasActiveJourney,
                activeJourneyId: model.activeJourneyId ?? ""
            )
        }
    }
}

struct WatchingPerson: Codable, Sendable {
    let guardianId: String
    let userId: String
    let fullName: String
    let phone: String
    let relationshipLabel: String
    let accessLevel: String
    let hasActiveJourney: Bool
    let activeJourneyId: String?
    
    enum CodingKeys: String, CodingKey {
        case guardianId = "guardian_id"
        case userId = "user_id"
        case fullName = "full_name"
        case phone
        case relationshipLabel = "relationship_label"
        case accessLevel = "access_level"
        case hasActiveJourney = "has_active_journey"
        case activeJourneyId = "active_journey_id"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.guardianId = try container.decode(String.self, forKey: .guardianId)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.fullName = try container.decode(String.self, forKey: .fullName)
        self.phone = try container.decode(String.self, forKey: .phone)
        self.relationshipLabel = try container.decode(String.self, forKey: .relationshipLabel)
        self.accessLevel = try container.decode(String.self, forKey: .accessLevel)
        self.activeJourneyId = try container.decodeIfPresent(String.self, forKey: .activeJourneyId)
        if let boolVal = try? container.decode(Bool.self, forKey: .hasActiveJourney) {
                   hasActiveJourney = boolVal
        } else if let intVal = try? container.decode(Int.self, forKey: .hasActiveJourney) {
                   hasActiveJourney = (intVal != 0)
        } else {
                   hasActiveJourney = false
        }
    }
    
    
}

struct Meta: Codable {
    // Add fields when API starts returning meta data
}
//
//struct Errors: Codable {
//    // Add fields when API starts returning errors
//}
