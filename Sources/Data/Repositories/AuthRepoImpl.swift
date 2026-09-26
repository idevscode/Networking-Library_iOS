//
//  AuthRepoImpl.swift
//  Data
//
//  Created by Dilshad Haidari.
//

import Foundation
import Domain

final class AuthRepoImpl: AuthRepository {
    
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient = NetworkExecutor1()) {
        self.networkClient = networkClient
    }

    var hasValidSession: Bool {
        guard let token = KeychainManager.shared.getToken(), !token.isEmpty else {
            return false
        }
        return true
    }

    func createAccount(
        email: String,
        pin: String,
        dob: String,
        phone: String,
        emergencyContact1: String,
        emergencyContact2: String,
        fullName: String,
        gender: String
    ) async throws -> UserResponseEntity {
        let request = RegisterRequest(
            fullName: fullName,
            email: email,
            pin: pin,
            dob: dob,
            phone: phone,
            emergencyContact1: emergencyContact1,
            emergencyContact2: emergencyContact2,
            gender: gender
        )
        let registerResponse: RegisterAccountDTO = try await networkClient.execute(request)
        return registerResponse.toEntity()
    }
    
    func verifyOTP(phone: String, otp: String, flow: VerifyOTPFlow ) async throws -> VerifyOTPResponseEntity {
        let request = VerifyOTPRequest(phone: phone, otp: otp, flow: flow)
        let response: VerifyOTPResponseDTO = try await networkClient.execute(request)
        return response.toEntity()
    }
    
    func resetPin(resetToken: String, pin: String) async throws -> DefaultEntity {
        let request = ResetPinRequest(resetToken: resetToken, pin: pin)
        let response: DefaultResponseDTO = try await networkClient.execute(request)
        return response.toEntity()
    }
    
    func login(phone: String, pin: String, deviceInfo: String) async throws {
        let request = LoginRequest(phone: phone, pin: pin, deviceInfo: deviceInfo)
        let _: LoginDTO = try await networkClient.execute(request)
    }
    
    func logoutAll() async throws -> DefaultEntity {
        let request = LogoutAllRequest()
        let response: DefaultResponseDTO = try await networkClient.execute(request)
        return response.toEntity()
    }
    
    func forgotPin(phone: String) async throws -> DefaultEntity {
        let request = ForgotPinRequest(phone: phone)
        let response: DefaultResponseDTO = try await networkClient.execute(request)
        return response.toEntity()
    }

    func enrollBiometric(
        deviceId: String,
        deviceName: String,
        platform: String,
        publicKey: String,
        algorithm: String
    ) async throws -> BiometricEnrolResponseEntity {
        let request = BiometricEnrollRequest(
            deviceId: deviceId,
            deviceName: deviceName,
            platform: platform,
            publicKey: publicKey,
            algorithm: algorithm
        )
        let response: BiometricEnrolResponseDTO = try await networkClient.execute(request)
        return response.toEntity()
    }

    func getBiometricChallenge(
        phone: String,
        deviceId: String
    ) async throws -> BiometricChallengeResponseEntity {
        let request = BiometricChallengeRequest(phone: phone, deviceId: deviceId)
        let response: BiometricChallengeResponseDTO = try await networkClient.execute(request)
        return response.toEntity()
    }

    func verifyBiometric(
        phone: String,
        deviceId: String,
        challenge: String,
        signature: String
    ) async throws -> BiometricVerifyResponseEntity {
        let request = BiometricVerifyRequest(
            phone: phone,
            deviceId: deviceId,
            challenge: challenge,
            signature: signature
        )
        let response: BiometricVerifyResponseDTO = try await networkClient.execute(request)
        return response.toEntity()
    }

    func clearSession() {
        KeychainManager.shared.deleteToken()
    }
}
