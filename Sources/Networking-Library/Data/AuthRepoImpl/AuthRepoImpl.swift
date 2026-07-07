//
//  AuthRepository.swift
//  CleanArch
//
//  Created by Dilshad Haidari on 11/01/26.
//

import Foundation

class AuthRepoImpl: UserRepository {
    
    let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func getUserList() async throws -> [User] {
        do {
             let user : UserDTO = try await networkClient.execute("products")
            return [user.toUser() ?? User(id: 0, name: "-", email: "-")]
        } catch {
            throw error
        }
    }

}
