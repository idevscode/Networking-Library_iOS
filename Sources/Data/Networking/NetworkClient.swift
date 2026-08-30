//
//  NetworkClient.swift
//  Data
//

import Foundation
import Domain

public enum HTTPMethodType: String, Sendable {
    case GET = "GET"
    case POST = "POST"
}

enum NetworkError: Error, LocalizedError {
    case invalidResponse
    case invalidUrl
    case httpError(statusCode: Int, errorResponse: ErrorEntity)
    case decodingFailed
    case unsupportedPlatform

    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Invalid server response"
        case .invalidUrl:
            return "Invalid URL"
        case .httpError(_, let errorResponse):
            return errorResponse.message
        case .decodingFailed:
            return "Failed to process server response"
        case .unsupportedPlatform:
            return "Unsupported platform"
        }
    }
}

protocol NetworkClient: Sendable {
    func execute<T: Decodable & Sendable>(_ request: RequestProtocol) async throws -> T
}

final class NetworkExecutor1: NetworkClient {
    init() {}

    func execute<T>(_ request: RequestProtocol) async throws -> T where T: Decodable & Sendable {
        guard let theRequest = prepareRequest(request: request) else {
            throw NetworkError.invalidUrl
        }

        let (data, resp) = try await URLSession.shared.data(for: theRequest)
        guard let theResponse = resp as? HTTPURLResponse else {
            print("resp \(resp)")
            throw NetworkError.invalidResponse
        }

        guard (200...300).contains(theResponse.statusCode) else {
            print("❌ HTTP Status Code: \(theResponse.statusCode)")

            do {
                let parsedError1 = try JSONSerialization.jsonObject(with: data, options: [])

                print("parsedError: \(parsedError1)")
            } catch {
                print("Failed to parse JSON: \(error)")
            }
            
            
            let parsedError = try JSONDecoder().decode(ErrorResponseDTO.self, from: data)
                print("parsedError : \(parsedError)")
            
            
            throw NetworkError.httpError(statusCode: theResponse.statusCode, errorResponse: parsedError.toEntity())
            
        }
        
        do {
            let parsedError1 = try JSONSerialization.jsonObject(with: data, options: [])

            print("parsedError: \(parsedError1)")
        } catch {
            print("Failed to parse JSON: \(error)")
        }

        do {
            let parsedJson = try JSONDecoder().decode(T.self, from: data)
            print("json--->: \(parsedJson)")
            return parsedJson
        } catch {
            print("Decoding error: \(error)")
            throw NetworkError.decodingFailed
        }
    }
}
