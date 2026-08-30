//
//  VerifyOTPDTO.swift
//  Networking-Library_iOS
//
//  Created by Dilshad Haidari on 29/08/26.
//
/*
{
  "success": true,
  "message": "Request completed successfully",
  "data": null,
  "meta": {},
  "errors": {}
}
*/
import Foundation
import Domain

nonisolated struct DefaultResponseDTO: Decodable, Sendable {
    let success: Bool
    let message: String
//    let data: String?
//    let meta: [String: Any]
//    let errors: [String: Any]
    
    func toEntity() -> DefaultEntity {
        DefaultEntity(success: success, message: message)
    }
}
