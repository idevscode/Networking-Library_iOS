//
//  NetworkClient.swift
//  CleanArch
//
//  Created by Dilshad Haidari on 11/01/26.
//

import Foundation

public enum HTTPMethodType: String {
    case GET = "GET"
    case POST = "POST"
}

protocol NetworkClient {
    func execute<T: Codable & Sendable>(_ request: RequestProtocol) async throws -> T
}
enum NetworkError: Error{
    case invalidResponse
    case invalidUrl
    case httpError(statusCode: Int)
    case decodingFailed
    case unsupportedPlatform
}

final class NetworkExecutor1: NetworkClient {
    
     func execute<T>(_ request: RequestProtocol) async throws -> T where T : Decodable & Encodable & Sendable {
        
        guard let theRequest =  prepareRequest(request: request) else {
            throw NetworkError.invalidUrl
        }
        
        let (data, resp) = try await URLSession.shared.data(for: theRequest)
        guard let theResponse = resp as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200...300).contains(theResponse.statusCode) else {
            throw NetworkError.httpError(statusCode: theResponse.statusCode)
        }
        
        do {
            let parsedJson = try JSONDecoder().decode(T.self, from: data)
            print("json--->: \(parsedJson)")
            return parsedJson
            
        } catch {
            throw NetworkError.decodingFailed
        }
        
    }
}
