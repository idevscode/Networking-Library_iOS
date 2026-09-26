//
//  UserDefaultsManager.swift
//  Networking-Library_iOS
//
//  Created by Dilshad Haidari on 08/09/26.
//
import Domain
import Foundation
import Security

public final class UserDefaultsManager: UserRepository {
    
    public static let shared = UserDefaultsManager()
    public init() {}
    
    private let defaults = UserDefaults.standard
    
    // MARK: - Keychain constants for phone (PII — stored securely)
    private let phoneService = "com.pixelflow.safecircle"
    private let phoneAccount = "user-mobile"
    
    public var email: String? {
        get {
            defaults.string(forKey: KeyName.email)
        }
        set {
            defaults.set(newValue, forKey: KeyName.email)
        }
    }
    
    public var phone: String? {
        get {
            readPhoneFromKeychain()
        }
        set {
            if let value = newValue {
                savePhoneToKeychain(value)
            } else {
                deletePhoneFromKeychain()
            }
        }
    }
    
    public var name: String? {
        get {
            defaults.string(forKey: KeyName.name)
        }
        set {
            defaults.set(newValue, forKey: KeyName.name)
        }
    }
    
    public var userId: String? {
        get {
            defaults.string(forKey: KeyName.userId)
        }
        set {
            defaults.set(newValue, forKey: KeyName.userId)
        }
    }
    
    public var isLocationSharingEnabled: Bool {
        get {
            if defaults.object(forKey: "com.safecircle.isLocationSharingEnabled") == nil { return true }
            return defaults.bool(forKey: "com.safecircle.isLocationSharingEnabled")
        }
        set {
            defaults.set(newValue, forKey: "com.safecircle.isLocationSharingEnabled")
        }
    }
    
    public var isEmergencyAlertsEnabled: Bool {
        get {
            if defaults.object(forKey: "com.safecircle.isEmergencyAlertsEnabled") == nil { return true }
            return defaults.bool(forKey: "com.safecircle.isEmergencyAlertsEnabled")
        }
        set {
            defaults.set(newValue, forKey: "com.safecircle.isEmergencyAlertsEnabled")
        }
    }
    
    public var isAudioVideoOnSOSEnabled: Bool {
        get {
            defaults.bool(forKey: "com.safecircle.isAudioVideoOnSOSEnabled")
        }
        set {
            defaults.set(newValue, forKey: "com.safecircle.isAudioVideoOnSOSEnabled")
        }
    }
    
    public func setBiometric(enabled: Bool) {
        guard let theUserId = defaults.string(forKey: KeyName.userId) else { return }
        defaults.set(enabled, forKey: theUserId)
    }
    
    public func getBiometric() -> Bool {
        guard let theUserId = defaults.string(forKey: KeyName.userId) else {
            return false
        }
        return defaults.bool(forKey: theUserId)
    }
    
    public func clearUserData() {
        defaults.removeObject(forKey: KeyName.name)
        defaults.removeObject(forKey: KeyName.email)
        defaults.removeObject(forKey: KeyName.userId)
        deletePhoneFromKeychain()
    }
    
    // MARK: - Private Keychain helpers for phone
    
    private func savePhoneToKeychain(_ phone: String) {
        let data = Foundation.Data(phone.utf8)
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: phoneService,
            kSecAttrAccount as String: phoneAccount,
            kSecValueData as String: data
        ]
        
        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }
    
    private func readPhoneFromKeychain() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: phoneService,
            kSecAttrAccount as String: phoneAccount,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        
        guard SecItemCopyMatching(
            query as CFDictionary,
            &result
        ) == errSecSuccess,
        let data = result as? Foundation.Data else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
    
    private func deletePhoneFromKeychain() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: phoneService,
            kSecAttrAccount as String: phoneAccount
        ]
        
        SecItemDelete(query as CFDictionary)
    }
}
