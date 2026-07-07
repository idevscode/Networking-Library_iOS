//
//  NetworkClient.swift
//  CleanArch
//
//  Created by Dilshad Haidari on 11/01/26.
//

import Foundation

protocol NetworkClient {
    func execute<T: Codable & Sendable>(_ input: String) async throws -> T
}
enum NetworkError: Error{
    case invalidResponse
    case invalidUrl
    case httpError(statusCode: Int)
    case decodingFailed
    case unsupportedPlatform
}

class NetworkExecutor1: NetworkClient {
    
    func execute<T>(_ path: String) async throws -> T where T : Decodable & Encodable & Sendable {
        
        guard let url =  URL(string: "https://api.escuelajs.co/api/v1/\(path)") else {
            throw NetworkError.invalidUrl
        }
        
        if #available(iOS 15.0, *) {
            let (data, resp) = try await URLSession.shared.data(for: URLRequest(url: url))
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
        else {
            if #available(iOS 13.0, *) {
                return try await withCheckedThrowingContinuation { continuation in
                    let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, resp, error in
                        if let error = error {
                            continuation.resume(throwing: error)
                            return
                        }
                        guard let data = data, let resp = resp as? HTTPURLResponse else {
                            continuation.resume(throwing: NetworkError.invalidResponse)
                            return
                        }
                        guard (200...300).contains(resp.statusCode) else {
                            continuation.resume(throwing: NetworkError.httpError(statusCode: resp.statusCode))
                            return
                        }
                        do {
                            let parsedJson = try JSONDecoder().decode(T.self, from: data)
                            continuation.resume(returning: parsedJson)
                        } catch {
                            continuation.resume(throwing: NetworkError.decodingFailed)
                        }
                    }
                    task.resume()
                }
            } else {
                // Fallback on earlier versions
                throw NetworkError.unsupportedPlatform
            }
        }
    }
}
