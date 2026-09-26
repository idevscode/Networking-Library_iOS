//
//  UserRepository.swift
//  Domain
//
//  Created by Dilshad Haidari on 08/09/26.
//

import Foundation
public protocol UserRepository {
    var email: String? { get set }
    var name: String? { get set }
    var phone: String? {get set }
    var userId: String? {get set }
    
    func setBiometric(enabled: Bool)
    func getBiometric() -> Bool
    
}
