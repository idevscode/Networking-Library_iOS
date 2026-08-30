//
//  File.swift
//  Networking-Library_iOS
//
//  Created by Dilshad Haidari on 29/08/26.
//

import Foundation


struct LogoutAllRequest: RequestProtocol, Decodable, Sendable {
    var path: String {
        "api/v1/auth/logout-all"
    }
    
    var methodType: HTTPMethodType {
        .POST
    }
    
    var parameters: [String : Any]? {
        nil
    }
}
