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

    func login(email: String, password: String) async throws

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

    func logout()
}
