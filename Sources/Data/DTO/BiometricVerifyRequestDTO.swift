//
//  BiometricVerifyRequestDTO.swift
//  Data
//
//  Created by Dilshad Haidari on 31/08/26.
//

import Foundation
import Domain

// POST /api/v1/auth/biometric/verify Response
nonisolated public struct BiometricVerifyResponseDTO: Decodable, Sendable {
    public let success: Bool
    public let message: String
    public let data: BiometricVerifyDataDTO
    
    enum CodingKeys: String, CodingKey {
        case success
        case message
        case data
    }
    
    public func toEntity() -> BiometricVerifyResponseEntity {
        BiometricVerifyResponseEntity(
            success: success,
            message: message,
            data: data.toEntity()
        )
    }
}

nonisolated public struct BiometricVerifyDataDTO: Decodable, Sendable {
    public let tokens: AuthTokensDTO
    public let method: String
    
    enum CodingKeys: String, CodingKey {
        case tokens
        case method
    }
    
    public func toEntity() -> BiometricVerifyDataEntity {
        BiometricVerifyDataEntity(
            tokens: tokens.toEntity(),
            method: method
        )
    }
}

nonisolated public struct AuthTokensDTO: Decodable, Sendable {
    public let accessToken: String
    public let refreshToken: String
    public let tokenType: String
    public let expiresIn: Int
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
    }
    
    public func toEntity() -> AuthTokensEntity {
        AuthTokensEntity(
            accessToken: accessToken,
            refreshToken: refreshToken,
            tokenType: tokenType,
            expiresIn: expiresIn
        )
    }
}