//
//  PendingGuardianRequest.swift
//  Networking-Library_iOS
//
//  Created by Dilshad Haidari on 08/10/26.
//

import Foundation


struct PendingGuardianRequest: RequestProtocol, Codable, Sendable {

    var path: String {
        "api/v1/guardian/me/pending-invitations"
    }

    var methodType: HTTPMethodType {
        .GET
    }
    
    var parameters: [String : Any]? {
        [:]
    }
}
