//
//  NetworkClient.swift
//  CleanArch
//
//  Created by Dilshad Haidari on 11/01/26.
//

import Foundation

protocol NetworkClient {
    func
    execute<T: Codable>(_ input: String) async throws -> T
}
enum NetworkError: Error{
    case invalidResponse
    case invalidUrl
    case httpError(statusCode: Int)
    case decodingFailed
}

class NetworkExecutor1: NetworkClient {
    
    func execute<T>(_ path: String) async throws -> T where T : Decodable, T : Encodable {
        
        guard let url =  URL(string: "https://api.escuelajs.co/api/v1/\(path)") else {
            throw NetworkError.invalidUrl
        }
        
        if #available(iOS 15.0, *) {
            let (data, resp) = try await URLSession.shared.data(for: URLRequest(url: url))
        } else {
            try await withCheckedThrowingContinuation { continuation in
                let task = URLSession.shared.dataTask(with: URLRequest(url: url))
                if let error = error {
                    continuation.resume(throwing: error)
                }
                guard let data, let resp else {
                    continuation.resume(throwing: URLError(.badServerResponse))
                    return
                }
                continuation.resume(returning: (data, resp))
                
            }
        }
        
        guard let theResponse = resp as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200...300).contains(theResponse.statusCode) else {
            throw NetworkError.httpError(statusCode: theResponse.statusCode)
        }
        
        do {
            let parsedJson = try JSONDecoder().decode(T.self, from: data)
            return parsedJson
            
        } catch {
            throw NetworkError.decodingFailed
        }
        
        
        
        
    }
}


