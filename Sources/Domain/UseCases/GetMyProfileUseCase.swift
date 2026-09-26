//
//  GetMyProfileUseCase.swift
//  Domain
//
//  Single-responsibility use case: fetches the current user's profile.
//

import Foundation

public final class GetMyProfileUseCase {
    
    private let repository: MainRepository
    
    public init(repository: MainRepository) {
        self.repository = repository
    }
    
    public func execute() async throws -> UserResponseEntity {
        return try await repository.getMyProfile()
    }
}
