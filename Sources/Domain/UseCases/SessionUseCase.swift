//
//  SessionUseCase.swift
//  Domain
//
//  Protocol ONLY — the concrete implementation lives in Data.
//

import Foundation
import Combine

public protocol SessionUseCase: AnyObject {
    var isAuthenticated: Bool { get }
    var authStatePublisher: AnyPublisher<Bool, Never> { get }

    func login(phone: String, pin: String, deviceInfo: String) async throws

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
    
    func verifyOTP(phone: String, otp: String, flow: VerifyOTPFlow) async throws -> VerifyOTPResponseEntity

    func forgotPin(phone: String) async throws -> DefaultEntity
    
    func resetPin(resetToken: String, pin: String) async throws -> DefaultEntity

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

    /// Validates the current session by calling GetMe against the backend.
    /// Returns `true` if the stored token is still valid, `false` otherwise.
    func validateSession() async -> Bool

    func logout()
}
