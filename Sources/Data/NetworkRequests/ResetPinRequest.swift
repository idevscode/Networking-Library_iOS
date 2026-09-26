//
//  ResetPinRequest.swift
//  Networking-Library_iOS
//
//  Created by Dilshad Haidari on 22/09/26.
//

import Foundation

struct ResetPinRequest: RequestProtocol, Codable, Sendable {
    let resetToken: String
    let pin: String
    
    init(
        resetToken: String,
        pin: String,
    ) {
        self.resetToken = resetToken
        self.pin = pin
    }

    var path: String {
        "api/v1/auth/reset-pin"
    }

    var methodType: HTTPMethodType {
        .POST
    }

    var parameters: [String: Any]? {
        
        let body: [String: Any] = [
            "reset_token": resetToken,
            "new_pin": pin,
            "confirm_pin": pin
        ]

        return body
    }
}
