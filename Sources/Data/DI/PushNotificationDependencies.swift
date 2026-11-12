//
//  PushNotificationDependencies.swift
//  Networking-Library_iOS
//
//  Created by SafeCircle Team.
//

import Foundation
import Domain

public final class PushNotificationDependencies {

    public init() {}

    public static func makePushNotificationRepository() -> PushNotificationRepository {
        let networkClient = NetworkExecutor1()
        return PushNotificationRepoImpl(networkClient: networkClient)
    }

    public static func makeRegisterPushTokenUseCase() -> RegisterPushTokenUseCase {
        return DefaultRegisterPushTokenUseCase(repository: makePushNotificationRepository())
    }

    public static func makeUnregisterPushTokenUseCase() -> UnregisterPushTokenUseCase {
        return DefaultUnregisterPushTokenUseCase(repository: makePushNotificationRepository())
    }
}
