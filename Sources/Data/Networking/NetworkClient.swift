//
//  NetworkClient.swift
//  Data
//

import Foundation

public enum HTTPMethodType: String, Sendable {
    case GET = "GET"
    case POST = "POST"
}

enum NetworkError: Error {
    case invalidResponse
    case invalidUrl
    case httpError(statusCode: Int)
    case decodingFailed
    case unsupportedPlatform
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
            print("Decoding error: \(error)")
            throw NetworkError.decodingFailed
        }
    }
}
