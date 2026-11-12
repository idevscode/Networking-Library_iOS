//
//  PushTokenRequests.swift
//  Data
//
//  Created by SafeCircle Team.
//

import Foundation
import Domain

// MARK: - RegisterPushTokenRequest (POST api/v1/devices/push-tokens)
struct RegisterPushTokenRequest: RequestProtocol, Sendable {
    let token: String
    let platform: String
    let appRole: String
    let deviceId: String?
    let appVersion: String?

    var path: String {
        "api/v1/devices/push-tokens"
    }

    var methodType: HTTPMethodType {
        .POST
    }

    var parameters: [String: Any]? {
        var body: [String: Any] = [
            "token": token,
            "platform": platform,
            "app_role": appRole
        ]
        if let deviceId = deviceId {
            body["device_id"] = deviceId
        }
        if let appVersion = appVersion {
            body["app_version"] = appVersion
        }
        return body
    }
}

// MARK: - UnregisterPushTokenRequest (POST api/v1/devices/push-tokens/unregister)
struct UnregisterPushTokenRequest: RequestProtocol, Sendable {
    let token: String

    var path: String {
        "api/v1/devices/push-tokens/unregister"
    }

    var methodType: HTTPMethodType {
        .POST
    }

    var parameters: [String: Any]? {
        [
            "token": token
        ]
    }
}

// MARK: - TestPushRequest (POST api/v1/devices/push-tokens/test)
struct TestPushRequest: RequestProtocol, Sendable {
    var path: String {
        "api/v1/devices/push-tokens/test"
    }

    var methodType: HTTPMethodType {
        .POST
    }

    var parameters: [String: Any]? {
        nil
    }
}
