//
//  GuardianJourneyDataTests.swift
//  DataTests
//
//  Created by Dilshad Haidari on 18/10/26.
//

import XCTest
import Domain
@testable import Data

// MARK: - MockNetworkClient
private final class MockNetworkClient: NetworkClient, @unchecked Sendable {
    var executedRequest: RequestProtocol?
    var resultToReturn: Any?
    var errorToThrow: Error?

    func execute<T: Decodable & Sendable>(_ request: RequestProtocol) async throws -> T {
        self.executedRequest = request
        if let error = errorToThrow {
            throw error
        }
        guard let result = resultToReturn as? T else {
            fatalError("MockNetworkClient resultToReturn type mismatch or nil for type \(T.self)")
        }
        return result
    }
}

final class GuardianJourneyDataTests: XCTestCase {

    func testWatchingJourneyShareResponseDTODecoding() throws {
        let jsonString = """
        {
          "success": 1,
          "message": "Watch token issued",
          "data": {
            "guardian_id": "28b17989-65fc-4033-b1d9-7d21b624fed6",
            "guardian_name": "Sandeep kumar",
            "share_token": "token-test-123",
            "websocket_url": "/ws/journeys/2754b4c4-db4d-42f6-8fe9-7e6754afeef1?token=xyz",
            "expires_in_hours": 12
          },
          "meta": null,
          "errors": null
        }
        """

        let data = jsonString.data(using: .utf8)!
        let dto = try JSONDecoder().decode(WatchingJourneyShareResponseDTO.self, from: data)

        XCTAssertTrue(dto.success)
        XCTAssertEqual(dto.message, "Watch token issued")
        XCTAssertEqual(dto.data?.guardianId, "28b17989-65fc-4033-b1d9-7d21b624fed6")
        XCTAssertEqual(dto.data?.guardianName, "Sandeep kumar")
        XCTAssertEqual(dto.data?.shareToken, "token-test-123")
        XCTAssertEqual(dto.data?.websocketUrl, "/ws/journeys/2754b4c4-db4d-42f6-8fe9-7e6754afeef1?token=xyz")
        XCTAssertEqual(dto.data?.expiresInHours, 12)

        let entities = dto.toEntity()
        XCTAssertEqual(entities.count, 1)
        XCTAssertEqual(entities[0].guardianId, "28b17989-65fc-4033-b1d9-7d21b624fed6")
        XCTAssertEqual(entities[0].guardianName, "Sandeep kumar")
        XCTAssertEqual(entities[0].shareToken, "token-test-123")
        XCTAssertEqual(entities[0].websocketUrl, "/ws/journeys/2754b4c4-db4d-42f6-8fe9-7e6754afeef1?token=xyz")
        XCTAssertEqual(entities[0].expiresInHours, 12)
    }

    func testJourneySharesResponseDTODecoding() throws {
        let jsonString = """
        {
          "success": true,
          "message": "Request completed successfully",
          "data": [
            {
              "guardian_id": "guardian-123",
              "guardian_name": "Alice Smith",
              "share_token": "token-xyz-789",
              "websocket_url": "wss://api.safecircle.com/ws/journeys/shares",
              "expires_in_hours": 24
            }
          ],
          "meta": {},
          "errors": {}
        }
        """

        let data = jsonString.data(using: .utf8)!
        let dto = try JSONDecoder().decode(JourneySharesResponseDTO.self, from: data)

        XCTAssertTrue(dto.success)
        XCTAssertEqual(dto.message, "Request completed successfully")
        XCTAssertEqual(dto.data?.count, 1)

        let share = dto.data?.first
        XCTAssertEqual(share?.guardianId, "guardian-123")
        XCTAssertEqual(share?.guardianName, "Alice Smith")
        XCTAssertEqual(share?.shareToken, "token-xyz-789")
        XCTAssertEqual(share?.websocketUrl, "wss://api.safecircle.com/ws/journeys/shares")
        XCTAssertEqual(share?.expiresInHours, 24)

        let entities = dto.toEntity()
        XCTAssertEqual(entities.count, 1)
        XCTAssertEqual(entities[0].id, "guardian-123")
        XCTAssertEqual(entities[0].guardianId, "guardian-123")
        XCTAssertEqual(entities[0].guardianName, "Alice Smith")
        XCTAssertEqual(entities[0].shareToken, "token-xyz-789")
        XCTAssertEqual(entities[0].websocketUrl, "wss://api.safecircle.com/ws/journeys/shares")
        XCTAssertEqual(entities[0].expiresInHours, 24)
    }

    func testJourneySharesResponseDTODecodingSingleDictionary() throws {
        let jsonString = """
        {
          "success": 1,
          "message": "Watch token issued",
          "data": {
            "guardian_id": "g-single",
            "guardian_name": "Single Guardian",
            "share_token": "tok-single",
            "websocket_url": "/ws/single",
            "expires_in_hours": 6
          }
        }
        """

        let data = jsonString.data(using: .utf8)!
        let dto = try JSONDecoder().decode(JourneySharesResponseDTO.self, from: data)

        XCTAssertTrue(dto.success)
        XCTAssertEqual(dto.data?.count, 1)
        XCTAssertEqual(dto.data?.first?.guardianId, "g-single")
        XCTAssertEqual(dto.toEntity().count, 1)
    }

    func testJourneySharesResponseDTODecodingWithNullOrEmptyData() throws {
        let jsonStringEmptyData = """
        {
          "success": true,
          "message": "No shares active",
          "data": [],
          "meta": {},
          "errors": {}
        }
        """

        let emptyData = jsonStringEmptyData.data(using: .utf8)!
        let emptyDTO = try JSONDecoder().decode(JourneySharesResponseDTO.self, from: emptyData)
        XCTAssertTrue(emptyDTO.success)
        XCTAssertEqual(emptyDTO.toEntity().count, 0)

        let jsonStringNullData = """
        {
          "success": true,
          "message": "Request completed successfully",
          "data": null,
          "meta": {},
          "errors": {}
        }
        """

        let nullData = jsonStringNullData.data(using: .utf8)!
        let nullDTO = try JSONDecoder().decode(JourneySharesResponseDTO.self, from: nullData)
        XCTAssertTrue(nullDTO.success)
        XCTAssertEqual(nullDTO.toEntity().count, 0)
    }

    func testGetJourneySharesRequestProperties() {
        let guardianId = "test-guardian-999"
        let request = GetJourneySharesRequest(guardianId: guardianId)

        XCTAssertEqual(request.path, "api/v1/guardian/me/watching/test-guardian-999/journey-share")
        XCTAssertEqual(request.methodType, .POST)
        XCTAssertNil(request.parameters)
    }

    func testGuardianJourneyRepoImplSuccess() async throws {
        let mockClient = MockNetworkClient()
        let fakeShareDTO = WatchingJourneyShareResponseDTO(
            success: true,
            message: "Watch token issued",
            data: JourneyShareDTO(
                guardianId: "g-1",
                guardianName: "Bob",
                shareToken: "token-abc",
                websocketUrl: "wss://safecircle/ws",
                expiresInHours: 12
            )
        )
        mockClient.resultToReturn = fakeShareDTO

        let repo = GuardianJourneyRepoImpl(networkClient: mockClient)
        let shares = try await repo.getJourneyShares(guardianId: "guardian-456")

        XCTAssertEqual(mockClient.executedRequest?.path, "api/v1/guardian/me/watching/guardian-456/journey-share")
        XCTAssertEqual(mockClient.executedRequest?.methodType, .POST)
        XCTAssertEqual(shares.count, 1)
        XCTAssertEqual(shares[0].guardianId, "g-1")
        XCTAssertEqual(shares[0].guardianName, "Bob")
        XCTAssertEqual(shares[0].shareToken, "token-abc")
        XCTAssertEqual(shares[0].websocketUrl, "wss://safecircle/ws")
        XCTAssertEqual(shares[0].expiresInHours, 12)
    }

    func testGuardianJourneyRepoImplConvenienceGetShares() async throws {
        let mockClient = MockNetworkClient()
        let fakeShareDTO = WatchingJourneyShareResponseDTO(
            success: true,
            message: "Success",
            data: nil
        )
        mockClient.resultToReturn = fakeShareDTO

        let repo = GuardianJourneyRepoImpl(networkClient: mockClient)
        let shares = try await repo.getShares(journeyId: "journey-convenience")

        XCTAssertEqual(mockClient.executedRequest?.path, "api/v1/guardian/me/watching/journey-convenience/journey-share")
        XCTAssertEqual(mockClient.executedRequest?.methodType, .POST)
        XCTAssertEqual(shares.count, 0)
    }

    func testGuardianJourneyRepoImplThrowsError() async {
        let mockClient = MockNetworkClient()
        mockClient.errorToThrow = NetworkError.invalidResponse

        let repo = GuardianJourneyRepoImpl(networkClient: mockClient)

        do {
            _ = try await repo.getJourneyShares(guardianId: "journey-fail")
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertTrue(error is NetworkError)
        }
    }
}
