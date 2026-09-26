//
//  GetMeRequest.swift
//  Networking-Library_iOS
//
//  Created by Dilshad Haidari on 29/08/26.
//

struct GetMeRequest: RequestProtocol, Codable, Sendable {

    var path: String {
        "api/v1/user/me"
    }

    var methodType: HTTPMethodType {
        .GET
    }
    
    var parameters: [String : Any]? {
        [:]
    }
}
