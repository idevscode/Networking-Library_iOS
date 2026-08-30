//
//  AuthRepoImpl.swift
//  Data
//

import Foundation
import Domain

final class AuthRepoImpl: AuthRepository {
    
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient = NetworkExecutor1()) {
        self.networkClient = networkClient
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
    
    func verifyOTP(phone: String, otp: String) async throws -> DefaultEntity {
        let request = VerifyOTPRequest(phone: phone, otp: otp)
        let response : DefaultResponseDTO = try await networkClient.execute(request)
        return response.toEntity()
    }
    
    
    func login(phone: String, pin: String, deviceInfo: String) async throws {
        let request = LoginRequest(phone: phone, pin: pin, deviceInfo: deviceInfo)
        let _: LoginDTO = try await networkClient.execute(request)
    }
    
    func logoutAll() async throws -> DefaultEntity {
        let request = LogoutAllRequest()
        let response : DefaultResponseDTO = try await networkClient.execute(request)
        return response.toEntity()
    }
    
    func forgotPin(phone: String) async throws -> DefaultEntity {
        let request = ForgotPinRequest(phone: phone)
        let response: DefaultResponseDTO = try await networkClient.execute(request)
        return response.toEntity()
    }

}
