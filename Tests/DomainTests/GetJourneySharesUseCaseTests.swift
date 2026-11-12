//
//  GetJourneySharesUseCaseTests.swift
//  DomainTests
//
//  Created by Dilshad Haidari on 18/10/26.
//

import XCTest
@testable import Domain

// MARK: - MockGuardianJourneyRepository
private final class MockGuardianJourneyRepository: GuardianJourneyRepository, @unchecked Sendable {
    var capturedJourneyId: String?
    var resultToReturn: [JourneyShareEntity] = []
    var errorToThrow: Error?
    var getJourneySharesCallCount = 0

    func getJourneyShares(guardianId: String) async throws -> [JourneyShareEntity] {
        getJourneySharesCallCount += 1
        capturedJourneyId = guardianId
        if let error = errorToThrow {
            throw error
        }
        return resultToReturn
    }
}

final class GetJourneySharesUseCaseTests: XCTestCase {

    func testExecuteSuccess() async throws {
        let mockRepo = MockGuardianJourneyRepository()
        let expectedShares = [
            JourneyShareEntity(
                guardianId: "guardian-001",
                guardianName: "Jane Doe",
                shareToken: "token-abc-123",
                websocketUrl: "wss://safecircle.test/ws/shares",
                expiresInHours: 48
            ),
            JourneyShareEntity(
                guardianId: "guardian-002",
                guardianName: "John Doe",
                shareToken: "token-xyz-456",
                websocketUrl: "wss://safecircle.test/ws/shares",
                expiresInHours: 24
            )
        ]
        mockRepo.resultToReturn = expectedShares

        let useCase = GetJourneySharesUseCase(repository: mockRepo)
        let shares = try await useCase.execute(journeyId: "journey-789")

        XCTAssertEqual(mockRepo.getJourneySharesCallCount, 1)
        XCTAssertEqual(mockRepo.capturedJourneyId, "journey-789")
        XCTAssertEqual(shares.count, 2)
        XCTAssertEqual(shares[0].guardianId, "guardian-001")
        XCTAssertEqual(shares[0].guardianName, "Jane Doe")
        XCTAssertEqual(shares[0].shareToken, "token-abc-123")
        XCTAssertEqual(shares[0].websocketUrl, "wss://safecircle.test/ws/shares")
        XCTAssertEqual(shares[0].expiresInHours, 48)
        XCTAssertEqual(shares[1].guardianId, "guardian-002")
        XCTAssertEqual(shares[1].guardianName, "John Doe")
    }

    func testExecutePropagatesError() async {
        enum TestError: Error, Equatable {
            case networkFailed
        }

        let mockRepo = MockGuardianJourneyRepository()
        mockRepo.errorToThrow = TestError.networkFailed

        let useCase = GetJourneySharesUseCase(repository: mockRepo)

        do {
            _ = try await useCase.execute(journeyId: "journey-error")
            XCTFail("Expected error to be thrown")
        } catch let error as TestError {
            XCTAssertEqual(error, .networkFailed)
            XCTAssertEqual(mockRepo.capturedJourneyId, "journey-error")
            XCTAssertEqual(mockRepo.getJourneySharesCallCount, 1)
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
}
