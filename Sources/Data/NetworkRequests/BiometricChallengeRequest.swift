//
//  BiometricChallengeRequest.swift
//  Data
//
//  Created by Dilshad Haidari on 31/08/26.
//

import Foundation

public struct BiometricChallengeRequest: RequestProtocol, Codable, Sendable {
    public let phone: String
    public let deviceId: String
    
    public init(phone: String, deviceId: String) {
        self.phone = phone
        self.deviceId = deviceId
    }
    
    var path: String {
        "api/v1/auth/biometric/challenge"
    }
    
    var methodType: HTTPMethodType {
        .POST
    }
    
    var parameters: [String: Any]? {
        [
            "phone": phone,
            "device_id": deviceId
        ]
    }
}
