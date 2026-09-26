//
//  TokenRepository.swift
//  Networking-Library_iOS
//
//  Created by Dilshad Haidari on 08/09/26.
//


public protocol TokenRepository {
    func saveToken(_ token: String)
    func getToken() -> String?
    func deleteToken()
}