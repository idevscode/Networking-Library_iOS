//
//  WatchingPersonUsecase.swift
//  Networking-Library_iOS
//
//  Created by Dilshad Haidari on 15/10/26.
//

import Foundation

public final class WatchingPersonUsecase {
    
    private let repository: MainRepository
    
    public init(repository: MainRepository) {
        self.repository = repository
    }
    
    public func execute() async throws -> [WatchingPersonEntity] {
        return try await repository.guardianWatchingPerson()
    }
}
