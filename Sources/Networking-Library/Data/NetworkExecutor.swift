//
//  NetworkExecutor.swift
//  CleanArch
//
//  Created by Dilshad Haidari on 30/01/26.
//
import Foundation

class NetworkExecutor: NetworkClient {
    
    
    
    
    func execute<T: Codable>(_ path: String) async throws -> T {
    
        guard let url = URL(string: "https://api.escuelajs.co/api/v1/\(path)") else {
            throw NetworkError.invalidUrl
        }
        
        let (data, response) = try await URLSession.shared.data(for: URLRequest(url: url))
        
        guard let resp = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200...300).contains(resp.statusCode) else {
            throw NetworkError.httpError(statusCode: resp.statusCode)
        }
        
        do {
            let fetchedData = try JSONDecoder().decode(T.self, from: data)
            return fetchedData
        } catch {
            throw NetworkError.decodingFailed
        }
    }
    
}
