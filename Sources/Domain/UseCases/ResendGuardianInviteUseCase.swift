//
//  ResendGuardianInviteUseCase.swift
//  Networking-Library_iOS
//
//  Created by Dilshad Haidari on 07/10/26.
//

public final class ResendGuardianInviteUseCase {
    private let repository: MainRepository

    public init(repository: MainRepository) {
        self.repository = repository
    }

    public func execute(
        guardianId: String
    ) async throws -> DefaultEntity {
        return try await repository.resendGuardianInviteRequest(guardianId: guardianId)
    }
}
