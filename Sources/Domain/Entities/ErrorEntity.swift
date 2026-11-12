//
//  ErrorEntity.swift
//  Networking-Library_iOS
//
//  Created by Dilshad Haidari on 22/08/26.
//

import Foundation

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

public enum DomainNetworkError: Error, LocalizedError, Sendable {
    case unauthorized
    case forbidden(message: String)
    case notFound(message: String)
    case serverError(statusCode: Int, message: String)
    case generic(message: String)

    public var errorDescription: String? {
        switch self {
        case .unauthorized:
            return "Session expired"
        case .forbidden(let message):
            return message.isEmpty ? "No longer available" : message
        case .notFound(let message):
            return message.isEmpty ? "The journey has ended" : message
        case .serverError(_, let message):
            return message
        case .generic(let message):
            return message
        }
    }
}
