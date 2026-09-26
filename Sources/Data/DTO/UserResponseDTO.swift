//
//  UserResponse.swift
//  Networking-Library_iOS
//
//  Created by Dilshad Haidari on 04/09/26.
//


import Foundation

// MARK: - UserResponse
struct UserResponse: Codable {
    let success: Bool
    let message: String
    let data: UserData
    let meta, errors: Errors
}

// MARK: - DataClass
struct UserData: Codable {
    let id, fullName, phone, email: String
    let gender: String
    let biometricEnabled, phoneVerified: Bool
    let createdAt, updatedAt: String
    let emergencyContacts: [String]

    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
        case phone, email, gender
        case biometricEnabled = "biometric_enabled"
        case phoneVerified = "phone_verified"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case emergencyContacts = "emergency_contacts"
    }
}

// MARK: - Errors
struct Errors: Codable {
}
