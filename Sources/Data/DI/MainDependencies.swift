//
//  MainDependencies.swift
//  Networking-Library_iOS
//
//  Created by Dilshad Haidari on 08/09/26.
//

import Foundation
import Domain

public final class MainDependencies {
    
    public init() {}
    
    
    public static func makeMainRepository() -> MainRepository {
        let networkClient = NetworkExecutor1()
        return MainRepositoryImpl(networkClient: networkClient)
    }
    
    public static func makeGetMyProfileUseCase() -> GetMyProfileUseCase {
        return GetMyProfileUseCase(repository: makeMainRepository())
    }
    
    public static func makeGuardianListUseCase() -> GetGuardianListUseCase {
        return GetGuardianListUseCase(repository: makeMainRepository())
    }
    
    public static func makeAddGuardianUseCase() -> AddGuardianUseCase {
        return AddGuardianUseCase(repository: makeMainRepository())
    }
    
    public static func makeAcceptGuardianInviteUseCase() -> AcceptGuardianInviteUseCase {
        return AcceptGuardianInviteUseCase(repository: makeMainRepository())
    }
    
    public static func makeUserRepository() -> UserRepository {
        UserDefaultsManager.shared
    }
}
