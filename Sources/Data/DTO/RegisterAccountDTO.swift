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
    let meta: MetaDTO?

    enum CodingKeys: String, CodingKey {
        case success
        case message
        case data
        case meta
    }

    init(
        success: Bool,
        message: String,
        data: UserDataDTO,
        meta: MetaDTO? = nil
    ) {
        self.success = success
        self.message = message
        self.data = data
        self.meta = meta
    }

    func toEntity() -> UserResponseEntity {
        UserResponseEntity(
            success: success,
            message: message,
            user: data.user.toEntity(),
            meta: meta?.toEntity()
        )
    }
}

nonisolated struct UserDataDTO: Decodable, Sendable {
    let user: UserDTO
    
    enum CodingKeys: String, CodingKey {
        case user
    }

    init(user: UserDTO) {
        self.user = user
    }

    func toEntity() -> UserEntity {
        user.toEntity()
    }
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

    init(
        id: String,
        fullName: String,
        phone: String,
        email: String,
        gender: String,
        biometricEnabled: Bool,
        phoneVerified: Bool,
        createdAt: String,
        emergencyContacts: [EmergencyContactDTO]
    ) {
        self.id = id
        self.fullName = fullName
        self.phone = phone
        self.email = email
        self.gender = gender
        self.biometricEnabled = biometricEnabled
        self.phoneVerified = phoneVerified
        self.createdAt = createdAt
        self.emergencyContacts = emergencyContacts
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        fullName = try container.decode(String.self, forKey: .fullName)
        phone = try container.decode(String.self, forKey: .phone)
        email = try container.decode(String.self, forKey: .email)
        gender = try container.decode(String.self, forKey: .gender)

        if let bioBool = try? container.decode(Bool.self, forKey: .biometricEnabled) {
            biometricEnabled = bioBool
        } else if let bioInt = try? container.decode(Int.self, forKey: .biometricEnabled) {
            biometricEnabled = (bioInt != 0)
        } else {
            biometricEnabled = false
        }

        if let pvBool = try? container.decode(Bool.self, forKey: .phoneVerified) {
            phoneVerified = pvBool
        } else if let pvInt = try? container.decode(Int.self, forKey: .phoneVerified) {
            phoneVerified = (pvInt != 0)
        } else {
            phoneVerified = false
        }

        createdAt = (try? container.decode(String.self, forKey: .createdAt)) ?? ""
        emergencyContacts = (try? container.decode([EmergencyContactDTO].self, forKey: .emergencyContacts)) ?? []
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

    init(debugOtp: String? = nil) {
        self.debugOtp = debugOtp
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let intOtp = try? container.decode(Int.self, forKey: .debugOtp) {
            self.debugOtp = String(intOtp)
        } else if let stringOtp = try? container.decode(String.self, forKey: .debugOtp) {
            self.debugOtp = stringOtp
        } else {
            self.debugOtp = nil
        }
    }

    func toEntity() -> MetaEntity {
        MetaEntity(otp: debugOtp)
    }
}

nonisolated struct EmergencyContactDTO: Decodable, Sendable {
    let id: String?
    let name: String?
    let phone: String?
    let priority: Int?
    let relationshipLabel: String?

    enum CodingKeys: String, CodingKey {
        case id, name, phone, priority
        case relationshipLabel = "relationship_label"
    }

    init(
        id: String? = nil,
        name: String? = nil,
        phone: String? = nil,
        priority: Int? = nil,
        relationshipLabel: String? = nil
    ) {
        self.id = id
        self.name = name
        self.phone = phone
        self.priority = priority
        self.relationshipLabel = relationshipLabel
    }

    init(from decoder: Decoder) throws {
        let container = try? decoder.container(keyedBy: CodingKeys.self)
        self.id = try? container?.decodeIfPresent(String.self, forKey: .id)
        self.name = try? container?.decodeIfPresent(String.self, forKey: .name)
        self.phone = try? container?.decodeIfPresent(String.self, forKey: .phone)
        self.priority = try? container?.decodeIfPresent(Int.self, forKey: .priority)
        self.relationshipLabel = try? container?.decodeIfPresent(String.self, forKey: .relationshipLabel)
    }

    func toEntity() -> EmergencyContactEntity {
        EmergencyContactEntity()
    }
}

nonisolated struct ErrorsDTO: Decodable, Sendable {}
