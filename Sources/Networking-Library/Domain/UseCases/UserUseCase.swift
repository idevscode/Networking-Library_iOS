//
//  UserUseCase.swift
//  CleanArchitectureExampleCode
//
//  Created by Dilshad Haidari on 16/12/25.
//


struct UserUseCase {
    
    let userRepository: UserRepository
    
    init(userRepository: UserRepository){
        self.userRepository = userRepository
    }
    
    func execute() async throws -> [User] {
        return try await self.userRepository.getUserList() as! [User]
    }
}

