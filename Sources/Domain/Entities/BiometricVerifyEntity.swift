//
//  BiometricVerifyEntity.swift
//  Domain
//
//  Created by Dilshad Haidari on 31/08/26.
//

import Foundation

public struct BiometricVerifyResponseEntity: Sendable {
    public let success: Bool
    public let message: String
    public let data: BiometricVerifyDataEntity
    
    public init(success: Bool, message: String, data: BiometricVerifyDataEntity) {
        self.success = success
        self.message = message
        self.data = data
    }
}

public struct BiometricVerifyDataEntity: Sendable {
    public let tokens: AuthTokensEntity
    public let method: String
    
    public init(tokens: AuthTokensEntity, method: String) {
        self.tokens = tokens
        self.method = method
    }
}

public struct AuthTokensEntity: Sendable {
    public let accessToken: String
    public let refreshToken: String
    public let tokenType: String
    public let expiresIn: Int
    
    public init(accessToken: String, refreshToken: String, tokenType: String, expiresIn: Int) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.tokenType = tokenType
        self.expiresIn = expiresIn
    }
}
