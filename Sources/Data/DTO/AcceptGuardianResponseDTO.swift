//
//  AcceptGuardianResponseDTO.swift
//  Networking-Library_iOS
//
//  Created by Dilshad Haidari on 25/09/26.
//

import Foundation
import Domain

struct AcceptGuardianResponseDTO: Decodable, Sendable {
    let success: Bool
    let message: String
    let data: AddGuardianDataDTO
    
    func toEntity() -> GuardianEntity {
        data.toEntity()
    }
}
