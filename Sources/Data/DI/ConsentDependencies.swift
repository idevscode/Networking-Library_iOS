//
//  ConsentDependencies.swift
//  Networking-Library_iOS
//
//  Created by Dilshad Haidari on 29/09/26.
//

import Foundation
import Domain

public final class ConsentDependencies {

    public init() {}

    public static func makeConsentRepository() -> ConsentRepository {
        let networkClient = NetworkExecutor1()
        return ConsentRepoImpl(networkClient: networkClient)
    }

    public static func makeGrantConsentUseCase() -> GrantConsentUseCase {
        return GrantConsentUseCase(repository: makeConsentRepository())
    }
}
