//
//  AuthDependencies.swift
//  Networking-Library_iOS
//
//  Created by Dilshad Haidari on 09/08/26.
//

public final class AuthDependencies {
    
    public let sendOTPUseCase: SendOTPUseCaseProtocol

    
    public init() {
        let networkClient = NetworkExecutor1()
        let repository = AuthRepoImpl(networkClient: networkClient)
        self.sendOTPUseCase = SendOTPUseCase(repository: repository)
    }
}
