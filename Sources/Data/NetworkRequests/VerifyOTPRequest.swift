//
//  VerifyOTPRequest.swift
//  Networking-Library_iOS
//
//  Created by Dilshad Haidari on 29/08/26.
//

import Domain

struct VerifyOTPRequest: RequestProtocol, Sendable {
    let phone: String
    let otp: String
    let flow: VerifyOTPFlow
    
    init(
        phone: String,
        otp: String,
        flow: VerifyOTPFlow
    ) {
        self.phone = phone
        self.otp = otp
        self.flow = flow
    }

    var path: String {
        return   flow == .signup ?
           "api/v1/auth/verify-phone"
           :
           "api/v1/auth/verify-otp"
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
