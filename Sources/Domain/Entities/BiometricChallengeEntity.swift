//
//  BiometricChallengeEntity.swift
//  Domain
//
//  Created by Dilshad Haidari on 31/08/26.
//

import Foundation

public struct BiometricChallengeResponseEntity: Sendable {
    public let success: Bool
    public let message: String
    public let data: BiometricChallengeDataEntity
    
    public init(success: Bool, message: String, data: BiometricChallengeDataEntity) {
        self.success = success
        self.message = message
        self.data = data
    }
}

public struct BiometricChallengeDataEntity: Sendable {
    public let challenge: String
    public let expiresIn: Int
    
    public init(challenge: String, expiresIn: Int) {
        self.challenge = challenge
        self.expiresIn = expiresIn
    }
}
