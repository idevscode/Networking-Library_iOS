//
//  NetworkRequest.swift
//  Networking-Library_iOS
//
//  Created by Dilshad Haidari on 08/08/26.
//

import Foundation

public protocol RequestProtocol: Sendable {
    var baseUrl: String { get }
    var path: String { get }
    var methodType: HTTPMethodType { get }
    var header: [String: String]? { get }
    var parameters: [String: String?]? { get }
//    var body: Encodable? { get }
}


extension NetworkExecutor1 {
    
    func prepareRequest(request: RequestProtocol) -> URLRequest? {
        
        let base = NetworkConstant.baseURL + request.path
        
        guard let url = URL(string: base) else {
            return nil
        }
        
        var urlRequest: URLRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = request.methodType.rawValue
        
        request.header?.forEach { (k: String, v: String) in
            urlRequest.setValue(v, forHTTPHeaderField: k)
        }
        
        if request.methodType == .POST, let parameters = request.parameters {
//            ✅ compactMapValues strips nil entries — JSONSerialization only receives String values
//            let cleanBody = parameters.compactMapValues { $0 }
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        }
        return urlRequest
    }
}

extension RequestProtocol {
     
    var baseUrl: String {
        NetworkConstant.baseURL
    }
    
    var header: [String: String]? {
        [
            "Content-Type": "application/json"
        ]
    }
}
