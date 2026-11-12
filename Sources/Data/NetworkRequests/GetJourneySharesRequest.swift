//
//  GetJourneySharesRequest.swift
//  Data
//
//  Created by Dilshad Haidari on 18/10/26.
//

import Foundation

struct GetJourneySharesRequest: RequestProtocol, Sendable {
    let guardianId: String

    init(guardianId: String) {
        self.guardianId = guardianId
    }

    init(journeyId: String) {
        self.guardianId = journeyId
    }

    var path: String {
        "api/v1/guardian/me/watching/\(guardianId)/journey-share"
    }

    var methodType: HTTPMethodType {
        .POST
    }

    var parameters: [String: Any]? {
        nil
    }
}
