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
//        authStateSubject.send(true)
        return entity
    }
    
    public func verifyOTP(phone: String, otp: String) async throws -> DefaultEntity{
        let entity: DefaultEntity = try await authRepository.verifyOTP(phone: phone, otp: otp)
        authStateSubject.send(true)
        return entity
    }
    
    public func forgotPin(phone: String) async throws -> DefaultEntity {
        return try await authRepository.forgotPin(phone: phone)
    }

    public func logout() {
        authRepository.clearSession()
        authStateSubject.send(false)
    }
}
