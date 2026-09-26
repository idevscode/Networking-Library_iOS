//
//  NetworkRequest.swift
//  Data
//

import Foundation

protocol RequestProtocol: Sendable {
    var baseUrl: String { get }
    var path: String { get }
    var methodType: HTTPMethodType { get }
    var header: [String: String]? { get }
    var parameters: [String: Any]? { get }
//    var isAuthRequired: Bool { get }
}

extension NetworkExecutor1 {
    func prepareRequest(request: RequestProtocol) -> URLRequest? {
        let base = NetworkConstant.baseURL + request.path

        guard let url = URL(string: base) else {
            return nil
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.methodType.rawValue

        request.header?.forEach { (k, v) in
            urlRequest.setValue(v, forHTTPHeaderField: k)
        }

        // Inject saved auth token from KeychainManager
        if let token = KeychainManager.shared.getToken(), !token.isEmpty {
            if urlRequest.value(forHTTPHeaderField: "Authorization") == nil {
                urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
            if urlRequest.value(forHTTPHeaderField: "Cookie") == nil {
                urlRequest.setValue("sc_access=\(token)", forHTTPHeaderField: "Cookie")
            }
        }

        if request.methodType == .POST, let parameters = request.parameters {
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
        ["Content-Type": "application/json"]
    }
}
