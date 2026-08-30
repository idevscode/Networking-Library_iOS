//
//  VerifyOTPEntity.swift
//  Networking-Library_iOS
//
//  Created by Dilshad Haidari on 29/08/26.
//

public struct DefaultEntity: Sendable {
    public let success: Bool
    public let message: String
    
    public init(success: Bool, message: String) {
        self.success = success
        self.message = message
    }
}
