//
//  File.swift
//  Networking-Library_iOS
//
//  Created by Dilshad Haidari on 08/09/26.
//

import Security
import Foundation
import Domain


actor KeychainManager : TokenRepository {
    
    static let shared = KeychainManager()

    private init() {}

    nonisolated func saveToken(_ token: String) {
        let data = Foundation.Data(token.utf8)

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: KeyName.accessToken,
            kSecValueData as String: data
        ]

        // Remove existing value first
        SecItemDelete(query as CFDictionary)

        let status = SecItemAdd(query as CFDictionary, nil)

        guard status == errSecSuccess else {
            print("Failed to save token: \(status)")
            return
        }
        
        print("data saved successfully: \(status)")
    }
    
    nonisolated func getToken() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: KeyName.accessToken,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var result: AnyObject?

        let status = SecItemCopyMatching(
            query as CFDictionary,
            &result
        )

        guard status == errSecSuccess,
              let data = result as? Data,
              let token = String(data: data, encoding: .utf8)
        else {
            return nil
        }

        return token
    }
    
    nonisolated func deleteToken() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: KeyName.accessToken
        ]

        SecItemDelete(query as CFDictionary)
    }

}


