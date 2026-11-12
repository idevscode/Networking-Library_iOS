//
//  ConsentRepoImpl.swift
//  Networking-Library_iOS
//
//  Created by Dilshad Haidari on 29/09/26.
//

import Foundation
import Domain

final class ConsentRepoImpl: ConsentRepository {

    private let networkClient: NetworkClient

    init(networkClient: NetworkClient = NetworkExecutor1()) {
        self.networkClient = networkClient
    }

    func grantConsent(
        subjectType: String,
        subjectId: String,
        scope: String,
        level: String
    ) async throws -> ConsentEntity {
        let request = GrantConsentRequest(
            subjectType: subjectType,
            subjectId: subjectId,
            scope: scope,
            level: level
        )
        let response: GrantConsentResponseDTO = try await networkClient.execute(request)
        guard response.success else {
            throw NSError(
                domain: "ConsentError",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: response.message]
            )
        }
        return response.toEntity()
    }
}
