//
//  AuthDependencies.swift
//  Data
//

import Foundation
import Domain

public final class AuthDependencies {
    public init() {}
    
    /// The public factory method to construct a SessionUseCase.
    /// Returns a Domain protocol; callers never see AuthRepoImpl or NetworkExecutor1.
    public static func makeSessionUseCase() -> SessionUseCase {
        let networkClient = NetworkExecutor1()
        let repository = AuthRepoImpl(networkClient: networkClient)
        return DefaultSessionUseCase(authRepository: repository)
    }

    public static func makeAuthRepository() -> AuthRepository {
        let networkClient = NetworkExecutor1()
        return AuthRepoImpl(networkClient: networkClient)
    }
}
