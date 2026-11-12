//
//  ConsentRequests.swift
//  Networking-Library_iOS
//
//  Created by Dilshad Haidari on 29/09/26.
//

import Foundation

// MARK: - GrantConsentRequest (POST api/v1/consent/grant)
struct GrantConsentRequest: RequestProtocol, Sendable {
    let subjectType: String
    let subjectId: String
    let scope: String
    let level: String

    var path: String {
        "api/v1/consent/grant"
    }

    var methodType: HTTPMethodType {
        .POST
    }

    var parameters: [String: Any]? {
        [
            "subject_type": subjectType,
            "subject_id": subjectId,
            "scope": scope,
            "level": level
        ]
    }
}
