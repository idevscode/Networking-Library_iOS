//
//  Resend.swift
//  Networking-Library_iOS
//
//  Created by Dilshad Haidari on 04/09/26.
//

import Foundation

struct ResendGuardianCodeRequest : RequestProtocol {
    
    let guardianId: String
    
    init (guardianId: String) {
        self.guardianId = guardianId
    }
    
    var path: String {
        "api/v1/guardian/\(guardianId)/resend-invite"
    }
    
    var methodType: HTTPMethodType {
        .POST
    }
    
    var parameters: [String : Any]? {
        nil
    }
}
