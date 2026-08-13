//
//  OTPVerificationDTO.swift
//  Networking-Library_iOS
//
//  Created by Dilshad Haidari on 09/08/26.
//

/*
 {
   "success": true,
   "message": "string",
   "data": {
     "id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
     "full_name": "string",
     "email": "string",
     "phone": "string",
     "auth_provider": "string",
     "is_active": true,
     "is_verified": true,
     "is_phone_verified": true,
     "created_at": "2026-08-09T13:19:52.156Z"
   },
   "debug_otp": "string"
 }
 */

public struct OTPVerificationResponseDTO: Codable, Sendable {
    public let success: Bool
    public let message: String
    public let data: OTPVerificationDTO
    
    enum CodingKeys: String, CodingKey {
        case success, message, data
    }
    
    func toDomain() -> OTPVerificationEntity {
        return data.toEntity()
    }
}

public struct OTPVerificationDTO: Codable, Sendable {
    public let id: String
    public let fullName: String
    public let email: String
    public let phone: String
    
    enum CodingKeys: String, CodingKey {
        case id, email, phone
        case fullName = "full_name"
    }
    
    func toEntity() -> OTPVerificationEntity {
        return OTPVerificationEntity(id: id, name: fullName, email: email, phone: phone)
    }
    
    
    
}
