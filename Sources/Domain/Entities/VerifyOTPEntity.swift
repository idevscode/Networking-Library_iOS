//
//  VerifyOTPEntity.swift
//  Domain
//
//  Created by Dilshad Haidari on 22/09/26.
//

import Foundation

public struct VerifyOTPResponseEntity: Sendable {
    public let success: Bool
    public let message: String
    public let data: VerifyOTPDataEntity
    
    public init(success: Bool, message: String, data: VerifyOTPDataEntity) {
        self.success = success
        self.message = message
        self.data = data
    }
}

public struct VerifyOTPDataEntity: Sendable {
    public let resetToken: String
    public let expiresIn: Int
    
    public init(resetToken: String, expiresIn: Int) {
        self.resetToken = resetToken
        self.expiresIn = expiresIn
    }
}
