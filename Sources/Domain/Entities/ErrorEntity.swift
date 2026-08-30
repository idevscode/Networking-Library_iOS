//
//  ErrorEntity.swift
//  Networking-Library_iOS
//
//  Created by Dilshad Haidari on 22/08/26.
//

public struct ErrorEntity: Sendable {
    public let message: String
    public let success: Bool
//    public let errorEntity: [ErrorMessageEnity]
    
    public init(message: String, success: Bool,/* errorEntity: [ErrorMessageEnity]*/) {
        self.message = message
        self.success = success
//        self.errorEntity = errorEntity
    }
    
}

public struct ErrorMessageEnity: Sendable {
    public let field: String
    public let message: String
    
    public init(field: String, message: String) {
        self.field = field
        self.message = message
    }
}
