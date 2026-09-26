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
            print("❌ parameters: \(String(describing: request.parameters)) ")
            print("❌ HTTP url: \(String(describing: theResponse.url)) ")
            print("❌ HTTP Status Code: \(theResponse.statusCode)")

            // ── 401 → force logout globally ──
            if theResponse.statusCode == 401 {
                print("🔒 401 Unauthorized — triggering automatic logout")
                SessionEventBus.shared.send(.unauthorized)
            }

            do {
                let parsedError1 = try JSONSerialization.jsonObject(with: data, options: [])
                print("url:", resp.url ?? "")
                print("parsedError: \(parsedError1)")
            } catch {
                print("Raw response:")
                print(String(data: data, encoding: .utf8) ?? "Unable to convert data to String")

                print("Failed to parse JSON: \(error)")
            }
            
            
            let parsedError = try JSONDecoder().decode(ErrorResponseDTO.self, from: data)
                print("parsedError : \(parsedError)")
            
            
            throw NetworkError.httpError(statusCode: theResponse.statusCode, errorResponse: parsedError.toEntity())
            
        }
        //Save auth token
        saveToken(request: request, response: theResponse)
        
        do {
            let parsedError1 = try JSONSerialization.jsonObject(with: data, options: [])
            print("url:", resp.url ?? "")
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


extension NetworkExecutor1 {
    func saveToken(request: RequestProtocol, response: HTTPURLResponse) {
        var headerFields = [String: String]()
        for (key, value) in response.allHeaderFields {
            headerFields["\(key)"] = "\(value)"
        }
        
        let targetUrl = response.url ?? URL(string: NetworkConstant.baseURL) ?? URL(string: "http://localhost")!
        let cookies = HTTPCookie.cookies(
            withResponseHeaderFields: headerFields,
            for: targetUrl
        )
        
        if let accessCookie = cookies.first(where: { $0.name == "sc_access" }) {
            let accessToken = accessCookie.value
            print("Access Token from Cookie:", accessToken)
            KeychainManager.shared.saveToken(accessToken)
            return
        }
        
        // Fallback check in Set-Cookie header directly
        for (headerKey, headerValue) in headerFields {
            if headerKey.lowercased() == "set-cookie" && headerValue.contains("sc_access=") {
                if let range = headerValue.range(of: "sc_access=") {
                    let substring = headerValue[range.upperBound...]
                    let token = substring.components(separatedBy: ";").first?.trimmingCharacters(in: .whitespaces) ?? ""
                    if !token.isEmpty {
                        print("Access Token from Set-Cookie header:", token)
                        KeychainManager.shared.saveToken(token)
                        return
                    }
                }
            }
        }
        
        // Fallback for Authorization / access_token header
        for (headerKey, headerValue) in headerFields {
            if headerKey.lowercased() == "authorization" && headerValue.lowercased().hasPrefix("bearer ") {
                let token = String(headerValue.dropFirst(7)).trimmingCharacters(in: .whitespaces)
                if !token.isEmpty {
                    print("Access Token from Authorization header:", token)
                    KeychainManager.shared.saveToken(token)
                    return
                }
            }
        }
    }
}

//enum Token {
//    
//    var token: [String: String] {
//        [
//            "Authorization": "Bearer \(KeychainManager.shared.getToken())"
//        ]
//    }
//}
