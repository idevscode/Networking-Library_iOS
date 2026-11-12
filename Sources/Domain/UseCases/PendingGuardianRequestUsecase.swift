//
//  PendingGuardianRequestUsecase.swift
//  Networking-Library_iOS
//
//  Created by Dilshad Haidari on 08/10/26.
//

public final class PendingGuardianUseCase {
    private let repository: MainRepository

    public init(repository: MainRepository) {
        self.repository = repository
    }

    public func execute() async throws -> [GuardianRequesterEntity] {
        return try await repository.pendingGuardianList()
    }
}
