//
//  RegisterAccountDTO.swift
//  Data
//

import Foundation
import Domain

nonisolated struct RegisterAccountDTO: Decodable, Sendable {
    let success: Bool
    let message: String
    let data: UserDataDTO
    let meta: MetaDTO
    enum CodingKeys: String, CodingKey {
        case success
        case message
        case data
        case meta
    }

    func toEntity() -> UserResponseEntity {
        UserResponseEntity(success: success, message: message, user: data.user.toEntity(), meta: meta.toEntity())
    }
}

nonisolated struct UserDataDTO: Decodable, Sendable {
    let user: UserDTO

    func toEntity() -> UserEntity { user.toEntity() }
}

nonisolated struct UserDTO: Decodable, Sendable {
    let id: String
    let fullName: String
    let phone: String
    let email: String
    let gender: String
    let biometricEnabled: Bool
    let phoneVerified: Bool
    let createdAt: String
    let emergencyContacts: [EmergencyContactDTO]
    
    

    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
        case phone
        case email
        case gender
        case biometricEnabled = "biometric_enabled"
        case phoneVerified = "phone_verified"
        case createdAt = "created_at"
        case emergencyContacts = "emergency_contacts"
        
    }

    func toEntity() -> UserEntity {
        UserEntity(
            id: id,
            fullName: fullName,
            phone: phone,
            email: email,
            gender: gender,
            biometricEnabled: biometricEnabled,
            phoneVerified: phoneVerified,
            createdAt: createdAt,
            emergencyContacts: emergencyContacts.map { $0.toEntity() }
        )
    }
}

nonisolated struct MetaDTO: Decodable, Sendable {
    let debugOtp: String?
    
    enum CodingKeys: String, CodingKey {
        case debugOtp = "debug_otp"
    }
    func toEntity() -> MetaEntity {
        MetaEntity(otp: debugOtp)
    }
    
}

nonisolated struct EmergencyContactDTO: Decodable, Sendable {
    func toEntity() -> EmergencyContactEntity {
        EmergencyContactEntity()
    }
}

nonisolated struct ErrorsDTO: Decodable, Sendable {}
