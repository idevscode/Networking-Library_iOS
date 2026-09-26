//
//  AcceptGuardianInviteUseCase.swift
//  Networking-Library_iOS
//
//  Created by Dilshad Haidari on 25/09/26.
//

import Foundation

public final class AcceptGuardianInviteUseCase {
    
    private let repository: MainRepository
    
    public init(repository: MainRepository) {
        self.repository = repository
    }
    
    public func execute(guardianId: String, code: String = "123456") async throws -> GuardianEntity {
        return try await repository.acceptGuardianRequest(guardianId: guardianId, code: code)
    }
}
