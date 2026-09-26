//
//  File.swift
//  Networking-Library_iOS
//
//  Created by Dilshad Haidari on 04/09/26.
//

import Foundation

public struct GuardianEntity: Sendable, Identifiable {
    public let id: String
    public let fullName: String
    public let email: String
    public let phone: String
    public let relationship: String
    public let status: String
    public var permission: Permission
    
    public init(id: String, fullName: String, email: String, phone: String, relationship: String, status: String, permission: Permission? = nil) {
        self.id = id
        self.fullName = fullName
        self.email = email
        self.phone = phone
        self.relationship = relationship
        self.status = status
        self.permission = permission ?? Permission(rawValue: status) ?? .always
    }
    
    public enum Permission: String, CaseIterable, Sendable, Identifiable {
        public var id: String { rawValue }
        case always = "Always"
        case journeyOnly = "Journey Only"
        case sos = "SOS Only"
    }
    
    public var permissions: Permission {
        get { permission }
        set { permission = newValue }
    }
}

public typealias Permission = GuardianEntity.Permission
