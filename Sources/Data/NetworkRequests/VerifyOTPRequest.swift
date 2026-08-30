//
//  VerifyOTPRequest.swift
//  Networking-Library_iOS
//
//  Created by Dilshad Haidari on 29/08/26.
//

struct VerifyOTPRequest: RequestProtocol, Codable, Sendable {
    let phone: String
    let otp: String
    
    init(
        phone: String,
        otp: String,
    ) {
        self.phone = phone
        self.otp = otp
    }

    var path: String {
        "api/v1/auth/verify-phone"
    }

    var methodType: HTTPMethodType {
        .POST
    }

    var parameters: [String: Any]? {
        
        let body: [String: Any] = [
            "phone": phone,
            "code": otp,
        ]

        return body
    }
}
