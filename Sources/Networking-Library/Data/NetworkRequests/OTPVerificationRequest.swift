//
//  OTPVerificationRequest.swift
//  Networking-Library_iOS
//
//  Created by Dilshad Haidari on 09/08/26.
//

final class OTPVerificationRequest: RequestProtocol, Codable {
    
    let phone: String
    let otp: String
    init(phone: String, otp: String) {
        self.phone = phone
        self.otp = otp
    }
    
    var path: String {
        "api/v1/auth/phone/verify-otp"
    }
    
    var methodType: HTTPMethodType {
        .POST
    }
    
    // ✅ Only include non-nil fields so JSONSerialization never sends NSNull
    var parameters: [String : String?]? {
        var body: [String: String] = [
            "phone": phone,
            "code": otp
        ]
//        return body.mapValues { Optional($0) }
        return body   // conform to protocol's [String: String?]?
    }
    
}
