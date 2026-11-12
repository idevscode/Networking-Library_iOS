//
//  RiskDetectionDependencies.swift
//  Networking-Library_iOS
//
//  Created by SafeCircle Team.
//

import Foundation
import Domain

public final class RiskDetectionDependencies {

    public init() {}

    public static func makeRiskDetectionRepository() -> RiskDetectionRepository {
        let networkClient = NetworkExecutor1()
        return RiskDetectionRepoImpl(networkClient: networkClient)
    }

    public static func makeGetActiveRisksUseCase() -> GetActiveRisksUseCase {
        return GetActiveRisksUseCase(repository: makeRiskDetectionRepository())
    }

    public static func makeGetJourneyRisksUseCase() -> GetJourneyRisksUseCase {
        return GetJourneyRisksUseCase(repository: makeRiskDetectionRepository())
    }

    public static func makeResolveRiskUseCase() -> ResolveRiskUseCase {
        return ResolveRiskUseCase(repository: makeRiskDetectionRepository())
    }
}
