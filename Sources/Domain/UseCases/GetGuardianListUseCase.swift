//
//  GetGuardianListUseCase.swift
//  Networking-Library_iOS
//
//  Created by Dilshad Haidari on 08/09/26.
//

import Foundation

public final class GetGuardianListUseCase {
    
    private let repository: MainRepository
    
    public init(repository: MainRepository) {
        self.repository = repository
    }
    
    public func execute() async throws -> [GuardianEntity] {
        return try await repository.getGuardianList()
    }
}
