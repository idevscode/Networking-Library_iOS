//
//  UserDTO.swift
//  CleanArch
//
//  Created by Dilshad Haidari on 12/01/26.
//

import Foundation

public struct UserDTO: Codable{
    let id: Int
    let name: String
    let email: String
    
    func toUser() -> User? {
        return User(id: id, name: name, email: email)
    }
}
