//
//  DefaultSessionUseCase.swift
//  Data
//

import Foundation
import Combine
import Domain

public final class DefaultSessionUseCase: SessionUseCase {
    private let authRepository: AuthRepository
    private let authStateSubject: CurrentValueSubject<Bool, Never>

    public var isAuthenticated: Bool { authStateSubject.value }
    public var authStatePublisher: AnyPublisher<Bool, Never> {
        authStateSubject.eraseToAnyPublisher()
    }

    public init(authRepository: AuthRepository) {
        self.authRepository = authRepository
        self.authStateSubject = CurrentValueSubject(authRepository.hasValidSession)
    }

    public func login(email: String, password: String) async throws {
        try await authRepository.login(email: email, password: password)
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
        authStateSubject.send(true)
        return entity
    }

    public func logout() {
        authRepository.clearSession()
        authStateSubject.send(false)
    }
}
