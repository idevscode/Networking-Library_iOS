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
            if #available(iOS 15.0, *) {
                let (data, response) = try await URLSession.shared.data(for: URLRequest(url: url))
            } else {
                try? await withCheckedContinuation({ continuation in
                    let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, resp, error
                        if let error = error {
                            continuation.resume(throwing: error)
                        }
                        guard let data, let resp else {
                            continuation.resume(throwing: URLError(.badServerResponse))
                            return
                        }
                        
                        continuation.resume(returning: (data, rsp))
                    }
                })
            }
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
