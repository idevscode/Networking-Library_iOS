//
//  File.swift
//  Networking-Library_iOS
//
//  Created by Dilshad Haidari on 04/09/26.
//

import Foundation

struct GetGuardianListRequest: RequestProtocol {
    
    var path: String {
        "api/v1/user/guardians"
    }
    
    var methodType: HTTPMethodType {
        .GET
    }
    
    var headers: [String: String]? {
        nil
    }
    
    var parameters: [String : Any]? {
        nil
    }
    
}
