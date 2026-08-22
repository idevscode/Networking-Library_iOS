//
//  RegisterRequest.swift
//  Data
//

import Foundation

struct RegisterRequest: RequestProtocol, Codable, Sendable {
    let fullName: String
    let email: String
    let pin: String
    let dob: String
    let phone: String
    let emergencyContact1: String
    let emergencyContact2: String
    let gender: String

    init(
        fullName: String,
        email: String,
        pin: String,
        dob: String,
        phone: String,
        emergencyContact1: String,
        emergencyContact2: String,
        gender: String
    ) {
        self.fullName = fullName
        self.email = email
        self.pin = pin
        self.dob = dob
        self.phone = phone
        self.emergencyContact1 = emergencyContact1
        self.emergencyContact2 = emergencyContact2
        self.gender = gender
    }

    var path: String {
        "api/v1/auth/register"
    }

    var methodType: HTTPMethodType {
        .POST
    }

    var parameters: [String: Any]? {
        var contactsArray: [[String: Any]] = []
        if !emergencyContact1.isEmpty {
            contactsArray.append([
                "name": "Emergency Contact 1",
                "phone": emergencyContact1,
                "relationship_label": "Primary Contact",
                "priority": 1
            ])
        }
        if !emergencyContact2.isEmpty {
            contactsArray.append([
                "name": "Emergency Contact 2",
                "phone": emergencyContact2,
                "relationship_label": "Secondary Contact",
                "priority": 2
            ])
        }

        let body: [String: Any] = [
            "full_name": fullName,
            "phone": phone,
            "email": email,
            "date_of_birth": dob,
            "gender": gender,
            "pin": pin,
            "confirm_pin": pin,
            "emergency_contacts": contactsArray
        ]

        return body
    }
}
