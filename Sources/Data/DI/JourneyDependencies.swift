//
//  JourneyDependencies.swift
//  Networking-Library_iOS
//
//  Created by Dilshad Haidari on 26/09/26.
//

import Foundation
import Domain

public final class JourneyDependencies {

    public init() {}

    public static func makeJourneyRepository() -> JourneyRepository {
        let networkClient = NetworkExecutor1()
        return JourneyRepoImpl(networkClient: networkClient)
    }

    public static func makeStartJourneyUseCase() -> StartJourneyUseCase {
        return StartJourneyUseCase(repository: makeJourneyRepository())
    }

    public static func makeGetActiveJourneyUseCase() -> GetActiveJourneyUseCase {
        return GetActiveJourneyUseCase(repository: makeJourneyRepository())
    }

    public static func makeStopJourneyUseCase() -> StopJourneyUseCase {
        return StopJourneyUseCase(repository: makeJourneyRepository())
    }

    public static func makeSendJourneyPingUseCase() -> SendJourneyPingUseCase {
        return SendJourneyPingUseCase(repository: makeJourneyRepository())
    }
}
