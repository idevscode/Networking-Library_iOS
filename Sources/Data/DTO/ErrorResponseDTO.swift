//
//  ErrorResponseDTO.swift
//  Networking-Library_iOS
//
//  Created by Dilshad Haidari on 22/08/26.
//
import Domain


struct ErrorResponseDTO: Decodable, Sendable {
    let message: String
    let success: Bool
//    let errors: [ ErrorMessageDTO ]
}

struct ErrorMessageDTO: Decodable, Sendable {
    let field: String
    let message: String
}

extension ErrorResponseDTO {
    func toEntity() -> ErrorEntity {
        ErrorEntity(message: message, success: success
//                    errorEntity: errors.map({ er in
//            er.toEntity()
//        })
        )
    }
}

extension ErrorMessageDTO {
    func toEntity() -> ErrorMessageEnity {
        ErrorMessageEnity(field: field, message: message)
    }
}
