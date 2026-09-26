//
//  AddGuardianUseCase.swift
//  Networking-Library_iOS
//
//  Created by Dilshad Haidari on 14/09/26.
//

import Foundation

public final class AddGuardianUseCase {
    private let repository: MainRepository

    public init(repository: MainRepository) {
        self.repository = repository
    }

    public func execute(
        fullName: String,
        email: String,
        phone: String? = nil,
        relationship: String? = nil
    ) async throws -> GuardianEntity {
        return try await repository.addGuardian(
            fullName: fullName,
            email: email,
            phone: phone,
            relationship: relationship
        )
    }
}
