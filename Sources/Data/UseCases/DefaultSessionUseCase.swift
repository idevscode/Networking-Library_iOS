//
//  DefaultSessionUseCase.swift
//  Data
//
//  Created by Dilshad Haidari.
//

import Foundation
import Combine
import Domain

public final class DefaultSessionUseCase: SessionUseCase {
    
    private let authRepository: AuthRepository
    private let getMyProfileUseCase: GetMyProfileUseCase
    private let authStateSubject: CurrentValueSubject<Bool, Never>

    public var isAuthenticated: Bool { authStateSubject.value }
    public var authStatePublisher: AnyPublisher<Bool, Never> {
        authStateSubject.eraseToAnyPublisher()
    }

    public init(authRepository: AuthRepository, getMyProfileUseCase: GetMyProfileUseCase) {
        self.authRepository = authRepository
        self.getMyProfileUseCase = getMyProfileUseCase
        self.authStateSubject = CurrentValueSubject(authRepository.hasValidSession)
    }

    public func login(phone: String, pin: String, deviceInfo: String) async throws {
        try await authRepository.login(phone: phone, pin: pin, deviceInfo: deviceInfo)
        authStateSubject.send(true)
    }

    public func createAccount(
        email: String,
        pin: String,
        dob: String,
        phone: String,
        emergencyContact1: String,
        emergencyContact2: String,
        fullName: String,
        gender: String
    ) async throws -> UserResponseEntity {
        let entity = try await authRepository.createAccount(
            email: email,
            pin: pin,
            dob: dob,
            phone: phone,
            emergencyContact1: emergencyContact1,
            emergencyContact2: emergencyContact2,
            fullName: fullName,
            gender: gender
        )
        return entity
    }
    
    public func verifyOTP(phone: String, otp: String, flow: VerifyOTPFlow) async throws -> VerifyOTPResponseEntity {
        let entity: VerifyOTPResponseEntity = try await authRepository.verifyOTP(phone: phone, otp: otp, flow: flow)
        if flow == .signup {
            authStateSubject.send(true)
        }
        
        return entity
    }
    
    public func forgotPin(phone: String) async throws -> DefaultEntity {
        return try await authRepository.forgotPin(phone: phone)
    }
    
    public func resetPin(resetToken: String, pin: String) async throws -> DefaultEntity {
        return try await authRepository.resetPin(resetToken: resetToken, pin: pin)
    }

    public func enrollBiometric(
        deviceId: String,
        deviceName: String,
        platform: String,
        publicKey: String,
        algorithm: String
    ) async throws -> BiometricEnrolResponseEntity {
        return try await authRepository.enrollBiometric(
            deviceId: deviceId,
            deviceName: deviceName,
            platform: platform,
            publicKey: publicKey,
            algorithm: algorithm
        )
    }

    public func getBiometricChallenge(
        phone: String,
        deviceId: String
    ) async throws -> BiometricChallengeResponseEntity {
        return try await authRepository.getBiometricChallenge(
            phone: phone,
            deviceId: deviceId
        )
    }

    public func verifyBiometric(
        phone: String,
        deviceId: String,
        challenge: String,
        signature: String
    ) async throws -> BiometricVerifyResponseEntity {
        let response = try await authRepository.verifyBiometric(
            phone: phone,
            deviceId: deviceId,
            challenge: challenge,
            signature: signature
        )
        authStateSubject.send(true)
        return response
    }

    public func validateSession() async -> Bool {
        guard isAuthenticated else { return false }
        do {
            _ = try await getMyProfileUseCase.execute()
            return true
        } catch {
            // Token invalid/expired — clear session
            print("🔒 validateSession failed: \(error) — clearing session")
            logout()
            return false
        }
    }

    public func logout() {
        authRepository.clearSession()
        authStateSubject.send(false)
    }
}
