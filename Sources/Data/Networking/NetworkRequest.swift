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
