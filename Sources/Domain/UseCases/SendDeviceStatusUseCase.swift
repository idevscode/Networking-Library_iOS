//
//  SendDeviceStatusUseCase.swift
//  Domain
//
//  Created by SafeCircle Team.
//

import Foundation

public protocol SendDeviceStatusUseCase: Sendable {
    func execute(journeyId: String, status: DeviceStatusEntity) async throws
}

public struct DefaultSendDeviceStatusUseCase: SendDeviceStatusUseCase {
    private let repository: JourneyRepository

    public init(repository: JourneyRepository) {
        self.repository = repository
    }

    public func execute(journeyId: String, status: DeviceStatusEntity) async throws {
        try await repository.sendDeviceStatus(journeyId: journeyId, status: status)
    }
}
