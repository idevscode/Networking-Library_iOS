//
//  LoginRequest.swift
//  Networking-Library_iOS
//
//  Created by Dilshad Haidari on 27/08/26.
//

import Foundation

struct LoginRequest: RequestProtocol, Codable, Sendable {
    let phone: String
    let pin: String
    let deviceInfo: String
    
    init(
        phone: String,
        pin: String,
        deviceInfo: String
    ) {
        self.phone = phone
        self.pin = pin
        self.deviceInfo = deviceInfo
    }

    var path: String {
        "api/v1/auth/login"
    }

    var methodType: HTTPMethodType {
        .POST
    }

    var parameters: [String: Any]? {
        
        let body: [String: Any] = [
            "phone": phone,
            "pin": pin,
            "device_info": deviceInfo,
        ]

        return body
    }
}
