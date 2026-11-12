//
//  File.swift
//  Networking-Library_iOS
//
//  Created by Dilshad Haidari on 15/10/26.
//

import Foundation

public struct WatchingPersonEntity: Sendable {
    
    public let guardianId: String
    public let userId: String
    public let fullName: String
    public let phone: String
    public let relationshipLabel: String
    public let accessLevel: String
    public let hasActiveJourney: Bool
    public let activeJourneyId: String
    
    public init(guardianId: String, userId: String, fullName: String, phone: String, relationshipLabel: String, accessLevel: String, hasActiveJourney: Bool, activeJourneyId: String) {
        self.guardianId = guardianId
        self.userId = userId
        self.fullName = fullName
        self.phone = phone
        self.relationshipLabel = relationshipLabel
        self.accessLevel = accessLevel
        self.hasActiveJourney = hasActiveJourney
        self.activeJourneyId = activeJourneyId
    }
    
}
