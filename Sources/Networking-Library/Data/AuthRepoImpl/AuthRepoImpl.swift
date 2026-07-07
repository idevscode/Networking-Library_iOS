//
//  AuthRepository.swift
//  CleanArch
//
//  Created by Dilshad Haidari on 11/01/26.
//

import Foundation

class AuthaRepoImpl: UserRepository {
    
    let networkCLient: NetworkClient
    
    init(networkCLient: NetworkClient) {
        self.networkCLient = networkCLient
    }
    
    func getUserList() async throws -> [User] {
        do {
             let user : UserDTO = try await networkCLient.execute("products")
            return [user.toUser() ?? User(id: 0, name: "-", email: "-")]
        } catch {
            throw error
        }
    }

}
