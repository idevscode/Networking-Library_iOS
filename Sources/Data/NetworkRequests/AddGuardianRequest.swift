//
//  AddGuardianRequest.swift
//  Networking-Library_iOS
//
//  Created by Dilshad Haidari on 14/09/26.
//

import Foundation

struct AddGuardianRequest: RequestProtocol {
    let fullName: String
    let email: String
    let phone: String?
    let relationshipLabel: String?

    init(
        fullName: String,
        email: String,
        phone: String? = nil,
        relationshipLabel: String? = nil
    ) {
        self.fullName = fullName
        self.email = email
        self.phone = phone
        self.relationshipLabel = relationshipLabel
    }

    var path: String {
        "api/v1/user/guardians"
    }

    var methodType: HTTPMethodType {
        .POST
    }

    var parameters: [String: Any]? {
        var body: [String: Any] = [
            "full_name": fullName,
            "email": email
        ]
        if let phone = phone, !phone.isEmpty {
            body["phone"] = phone
        }
        if let relationshipLabel = relationshipLabel, !relationshipLabel.isEmpty {
            body["relationship_label"] = relationshipLabel
        }
        
        return body
    }
}


