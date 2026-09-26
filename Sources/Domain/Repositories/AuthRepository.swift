//
//  AuthRepository.swift
//  Domain
//
//  Repository protocol — Domain layer.
//  Returns ONLY Domain Entities, never DTOs.
//

import Foundation

public protocol AuthRepository {
    var hasValidSession: Bool { get }

    func login(phone: String, pin: String, deviceInfo: String) async throws
    func verifyOTP(phone: String, otp: String, flow: VerifyOTPFlow) async throws -> VerifyOTPResponseEntity
    func logoutAll() async throws -> DefaultEntity
    func forgotPin(phone: String) async throws -> DefaultEntity
    func resetPin(resetToken: String, pin: String) async throws -> DefaultEntity

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

    func enrollBiometric(
        deviceId: String,
        deviceName: String,
        platform: String,
        publicKey: String,
        algorithm: String
    ) async throws -> BiometricEnrolResponseEntity

    func getBiometricChallenge(
        phone: String,
        deviceId: String
    ) async throws -> BiometricChallengeResponseEntity

    func verifyBiometric(
        phone: String,
        deviceId: String,
        challenge: String,
        signature: String
    ) async throws -> BiometricVerifyResponseEntity

    func clearSession()
}

// MARK: - Default implementations for optional methods

public extension AuthRepository {
    var hasValidSession: Bool { false }
    func login(phone: String, pin: String, deviceInfo: String) async throws {}
    func clearSession() {}
}
