//
//  GuardianJourneyRepoImpl.swift
//  Data
//
//  Created by Dilshad Haidari on 18/10/26.
//

import Foundation
import Domain

final class GuardianJourneyRepoImpl: GuardianJourneyRepository {
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient = NetworkExecutor1()) {
        self.networkClient = networkClient
    }

    func getJourneyShares(guardianId: String) async throws -> [JourneyShareEntity] {
        do {
            let request = GetJourneySharesRequest(guardianId: guardianId)
            let response: WatchingJourneyShareResponseDTO = try await networkClient.execute(request)
            return response.toEntity()
        } catch let NetworkError.httpError(statusCode, errorResponse) {
            if statusCode == 403 {
                throw DomainNetworkError.forbidden(message: errorResponse.message)
            } else if statusCode == 404 {
                throw DomainNetworkError.notFound(message: errorResponse.message)
            } else {
                throw DomainNetworkError.serverError(statusCode: statusCode, message: errorResponse.message)
            }
        } catch {
            throw error
        }
    }
}
