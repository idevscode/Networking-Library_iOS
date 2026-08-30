//
//  File.swift
//  Networking-Library_iOS
//
//  Created by Dilshad Haidari on 29/08/26.
//

import Foundation

struct ForgotPinRequest: RequestProtocol, Codable, Sendable {
    let phone: String
    
    init(
        phone: String
    ) {
        self.phone = phone
    }

    var path: String {
        "api/v1/auth/forgot-pin"
    }

    var methodType: HTTPMethodType {
        .POST
    }

    var parameters: [String: Any]? {
        
        let body: [String: Any] = [
            "phone": phone,
        ]

        return body
    }
}
