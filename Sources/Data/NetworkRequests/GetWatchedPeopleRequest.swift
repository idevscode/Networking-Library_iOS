//
//  GetWatchedPeopleRequest.swift
//  Networking-Library_iOS
//
//  Created by Dilshad Haidari on 15/10/26.
//

import Foundation

struct GetWatchedPeopleRequest : RequestProtocol {
    
    var path: String {
        "api/v1/guardian/me/watching"
    }
    
    var methodType: HTTPMethodType {
        .GET
    }
    
    var parameters: [String : Any]? {
        nil
    }
    
}
