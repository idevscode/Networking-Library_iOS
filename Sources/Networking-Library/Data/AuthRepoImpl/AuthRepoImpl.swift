//
//  AuthRepository.swift
//  CleanArch
//
//  Created by Dilshad Haidari on 11/01/26.
//

import Foundation

class AuthaRepoImpl: UserRepo {
    
    let networkCLient: NetworkClient
    
    init(networkCLient: NetworkClient) {
        self.networkCLient = networkCLient
    }
    
    func fetchUser() async throws -> User? {
        do{
            let request = URLRequest(url: URL(string: "")!)
             let user : UserDTO = try await networkCLient.execute("products")
            return user.toUser()
        } catch {
            throw error
        }
    }

}
