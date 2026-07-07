//
//  UserUseCase.swift
//  CleanArchitectureExampleCode
//
//  Created by Dilshad Haidari on 16/12/25.
//


public struct UserUseCase {
    
    public let userRepository: UserRepository
    
    public init(userRepository: UserRepository){
        self.userRepository = userRepository
    }
    
    public func execute() async throws -> [User] {
        return try await self.userRepository.getUserList()
    }
}

