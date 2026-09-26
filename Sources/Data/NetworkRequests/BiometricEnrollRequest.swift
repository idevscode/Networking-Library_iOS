//
//  BiometricEnrollRequest.swift
//  Data
//
//  Created by Dilshad Haidari on 31/08/26.
//

import Foundation

public struct BiometricEnrollRequest: RequestProtocol, Codable, Sendable {
    public let deviceId: String
    public let deviceName: String
    public let platform: String
    public let publicKey: String
    public let algorithm: String
    
    public init(
        deviceId: String,
        deviceName: String,
        platform: String = "iOS",
        publicKey: String,
        algorithm: String = "es256"
    ) {
        self.deviceId = deviceId
        self.deviceName = deviceName
        self.platform = platform
        self.publicKey = publicKey
        self.algorithm = algorithm
    }
  
    var path: String {
        "api/v1/auth/biometric/enrol"
    }

    var methodType: HTTPMethodType {
        .POST
    }

    var parameters: [String: Any]? {
        let body: [String: Any] = [
            "device_id": deviceId,
            "device_name": deviceName,
            "platform": platform,
            "public_key": publicKey,
            "algorithm": algorithm
        ]

        return body
    }
}
