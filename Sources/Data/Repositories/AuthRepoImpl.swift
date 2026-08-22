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

}
