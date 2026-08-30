//
//  UserEntity.swift
//  Domain
//

public struct UserResponseEntity: Sendable {
    public let success: Bool
    public let message: String
    public let user: UserEntity
    public let metaEntity: MetaEntity?

    public init(success: Bool, message: String, user: UserEntity, meta: MetaEntity? = nil) {
        self.success = success
        self.message = message
        self.user = user
        self.metaEntity = meta
    }
}

public struct UserEntity: Sendable {
    public let id: String
    public let fullName: String
    public let phone: String
    public let email: String
    public let gender: String
    public let biometricEnabled: Bool
    public let phoneVerified: Bool
    public let createdAt: String
    public let emergencyContacts: [EmergencyContactEntity]
    
    public init(id: String, fullName: String, phone: String, email: String, gender: String, biometricEnabled: Bool, phoneVerified: Bool, createdAt: String, emergencyContacts: [EmergencyContactEntity], meta: MetaEntity? = nil) {
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
}

public struct MetaEntity: Sendable {
    public let otp: String?
    
    public init(otp: String?) {
        self.otp = otp
    }
}

public struct EmergencyContactEntity: Sendable {
    public init() {}
}
