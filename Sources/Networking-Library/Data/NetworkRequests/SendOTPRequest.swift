//
//  File.swift
//  Networking-Library_iOS
//
//  Created by Dilshad Haidari on 08/08/26.
//

import Foundation

final class SendOTPRequest: RequestProtocol, Codable {
    
    let phone: String
    let intent: String
    let fullName: String?
    init(phone: String, intent: String, fullName: String? = nil) {
        self.fullName = fullName
        self.phone = phone
        self.intent = intent
    }
    
    var path: String {
        "api/v1/auth/phone/send-otp"
    }
    
    var methodType: HTTPMethodType {
        .POST
    }
    
    // ✅ Only include non-nil fields so JSONSerialization never sends NSNull
    var parameters: [String : String?]? {
        var body: [String: String] = [
            "phone": phone,
            "intent": intent
        ]
        if let name = fullName {
            body["full_name"] = name
        }
        return body.mapValues { Optional($0) }   // conform to protocol's [String: String?]?
    }
    
}
