//
//  UserRepository.swift
//  CleanArchitectureExampleCode
//
//  Created by Dilshad Haidari on 16/12/25.
//



protocol UserRepository {
    func getUserList() async throws -> [User]
}



