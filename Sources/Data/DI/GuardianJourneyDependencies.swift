//
//  GuardianJourneyDependencies.swift
//  Data
//
//  Created by Dilshad Haidari on 18/10/26.
//

import Foundation
import Domain

public final class GuardianJourneyDependencies {
    public init() {}

    public static func makeGuardianJourneyRepository() -> GuardianJourneyRepository {
        let networkClient = NetworkExecutor1()
        return GuardianJourneyRepoImpl(networkClient: networkClient)
    }

    static func makeGuardianJourneyRepository(networkClient: NetworkClient) -> GuardianJourneyRepository {
        return GuardianJourneyRepoImpl(networkClient: networkClient)
    }

    public static func makeGetJourneySharesUseCase() -> GetJourneySharesUseCase {
        return GetJourneySharesUseCase(repository: makeGuardianJourneyRepository())
    }

    public static func makeGetJourneySharesUseCase(repository: GuardianJourneyRepository) -> GetJourneySharesUseCase {
        return GetJourneySharesUseCase(repository: repository)
    }
}
