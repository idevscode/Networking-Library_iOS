//
//  File.swift
//  Networking-Library_iOS
//
//  Created by Dilshad Haidari on 04/09/26.
//

import Foundation

struct AcceptGuardianRequest : RequestProtocol {
    
    let guardianId: String
    let code: String
    
    init (guardianId: String, code: String) {
        self.guardianId = guardianId
        self.code = code
    }
    
    var path: String {
        "api/v1/guardian/\(guardianId)/accept-invite"
    }
    
    var methodType: HTTPMethodType {
        .POST
    }
    
    var parameters: [String : Any]? {
        [
            "code": code
        ]
    }
}
