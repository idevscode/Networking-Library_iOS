//
//  LoginDTO.swift
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

nonisolated struct LoginDTO: Decodable, Sendable {
    let success: Bool
    let message: String
}
