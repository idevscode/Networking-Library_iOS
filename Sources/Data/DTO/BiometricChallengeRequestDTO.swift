//
//  BiometricChallengeRequestDTO.swift
//  Data
//
//  Created by Dilshad Haidari on 31/08/26.
//

import Foundation
import Domain

// POST /api/v1/auth/biometric/challenge Response
nonisolated public struct BiometricChallengeResponseDTO: Decodable, Sendable {
    public let success: Bool
    public let message: String
    public let data: BiometricChallengeDataDTO
    
    enum CodingKeys: String, CodingKey {
        case success
        case message
        case data
    }
    
    public func toEntity() -> BiometricChallengeResponseEntity {
        BiometricChallengeResponseEntity(
            success: success,
            message: message,
            data: data.toEntity()
        )
    }
}

nonisolated public struct BiometricChallengeDataDTO: Decodable, Sendable {
    public let challenge: String
    public let expiresIn: Int
    
    enum CodingKeys: String, CodingKey {
        case challenge
        case expiresIn = "expires_in"
    }
    
    public func toEntity() -> BiometricChallengeDataEntity {
        BiometricChallengeDataEntity(
            challenge: challenge,
            expiresIn: expiresIn
        )
    }
}
