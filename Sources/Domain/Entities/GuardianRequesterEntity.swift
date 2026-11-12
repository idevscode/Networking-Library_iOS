//
//  GuardianRequesterEntity.swift
//  Networking-Library_iOS
//
//  Created by Dilshad Haidari on 13/10/26.
//

public struct GuardianRequesterEntity: Sendable, Identifiable {
    public let id: String
    public let requesterId: String?
    public let fullName: String
    public let email: String
    public let phone: String
    public let relationship: String
    public var status: String
    public var permission: Permission
    
    public init(
        id: String,
        requesterId: String? = nil,
        fullName: String,
        email: String,
        phone: String,
        relationship: String,
        status: String,
        permission: Permission? = nil
    ) {
        self.id = id
        self.requesterId = requesterId
        self.fullName = fullName
        self.email = email
        self.phone = phone
        self.relationship = relationship
        self.status = status
        self.permission = permission ?? Permission(rawValue: status) ?? .always
    }
    
    public init(
        id: String,
        requesterId: String? = nil,
        fullName: String,
        email: String,
        phone: String,
        relationship: String,
        status: Status,
        permission: Permission? = nil
    ) {
        self.init(
            id: id,
            requesterId: requesterId,
            fullName: fullName,
            email: email,
            phone: phone,
            relationship: relationship,
            status: status.rawValue,
            permission: permission
        )
    }
    
    public var permissions: Permission {
        get { permission }
        set { permission = newValue }
    }
    
    public init(from entity: GuardianEntity) {
        self.init(
            id: entity.id,
            fullName: entity.fullName,
            email: entity.email,
            phone: entity.phone,
            relationship: entity.relationship,
            status: entity.status.rawValue,
            permission: entity.permission
        )
    }

    public func toGuardianEntity() -> GuardianEntity {
        GuardianEntity(
            id: id,
            fullName: fullName,
            email: email,
            phone: phone,
            relationship: relationship,
            status: status,
            permission: permission
        )
    }
}

