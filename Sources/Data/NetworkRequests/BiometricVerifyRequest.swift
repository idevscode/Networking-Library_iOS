//
//  BiometricVerifyRequest.swift
//  Data
//
//  Created by Dilshad Haidari on 31/08/26.
//

import Foundation

public struct BiometricVerifyRequest: RequestProtocol, Codable, Sendable {
    public let phone: String
    public let deviceId: String
    public let challenge: String
    public let signature: String
    
    public init(phone: String, deviceId: String, challenge: String, signature: String) {
        self.phone = phone
        self.deviceId = deviceId
        self.challenge = challenge
        self.signature = signature
    }
    
    var path: String {
        "api/v1/auth/biometric/verify"
    }
    
    var methodType: HTTPMethodType {
        .POST
    }
    
    var parameters: [String: Any]? {
        [
            "phone": phone,
            "device_id": deviceId,
            "challenge": challenge,
            "signature": signature
        ]
    }
}
