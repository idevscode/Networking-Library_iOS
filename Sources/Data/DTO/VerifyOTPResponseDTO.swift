//
//  VerifyOTPResponseDTO.swift
//  Data
//
//  Created by Dilshad Haidari on 22/09/26.
//

/*
{
  "success": true,
  "message": "Code verified successfully",
  "data": {
    "reset_token": "eyJhbGciOiJIUzI1NiIs...",
    "expires_in": 600
  },
  "meta": null,
  "errors": null
}
*/

import Foundation
import Domain

// POST /api/v1/auth/verify-otp Response
nonisolated struct VerifyOTPResponseDTO: Decodable, Sendable {
    let success: Bool
    let message: String
    let data: VerifyOTPDataDTO
    
    enum CodingKeys: String, CodingKey {
        case success
        case message
        case data
    }
    
    func toEntity() -> VerifyOTPResponseEntity {
        VerifyOTPResponseEntity(
            success: success,
            message: message,
            data: data.toEntity()
        )
    }
}

nonisolated struct VerifyOTPDataDTO: Decodable, Sendable {
    let resetToken: String
    let expiresIn: Int
    
    enum CodingKeys: String, CodingKey {
        case resetToken = "reset_token"
        case expiresIn = "expires_in"
    }
    
    func toEntity() -> VerifyOTPDataEntity {
        VerifyOTPDataEntity(
            resetToken: resetToken,
            expiresIn: expiresIn
        )
    }
}
