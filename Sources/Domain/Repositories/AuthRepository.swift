//
//  AuthRepository.swift
//  Domain
//
//  Repository protocol — Domain layer.
//  Returns ONLY Domain Entities, never DTOs.
//

public protocol AuthRepository {
    var hasValidSession: Bool { get }

    func login(phone: String, pin: String, deviceInfo: String) async throws
    func verifyOTP(phone: String, otp: String) async throws -> DefaultEntity
    func logoutAll() async throws -> DefaultEntity
    func forgotPin(phone: String) async throws -> DefaultEntity

    func createAccount(
        email: String,
        pin: String,
        dob: String,
        phone: String,
        emergencyContact1: String,
        emergencyContact2: String,
        fullName: String,
        gender: String
    ) async throws -> UserResponseEntity

    func clearSession()
}

// MARK: - Default implementations for optional methods

public extension AuthRepository {
    var hasValidSession: Bool { false }
    func login(phone: String, pin: String, deviceInfo: String) async throws {}
    func clearSession() {}
    
}
