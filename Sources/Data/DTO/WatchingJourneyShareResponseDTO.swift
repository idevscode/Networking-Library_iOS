//
//  WatchingJourneyShareResponseDTO.swift
//  Data
//
//  Created by Dilshad Haidari on 23/10/26.
//

import Foundation
import Domain

nonisolated struct WatchingJourneyShareResponseDTO: Decodable, Sendable {
    let success: Bool
    let message: String
    let data: JourneyShareDTO?

    enum CodingKeys: String, CodingKey {
        case success
        case message
        case data
    }

    init(
        success: Bool = true,
        message: String = "",
        data: JourneyShareDTO? = nil
    ) {
        self.success = success
        self.message = message
        self.data = data
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        if let boolVal = try? container.decode(Bool.self, forKey: .success) {
            self.success = boolVal
        } else if let intVal = try? container.decode(Int.self, forKey: .success) {
            self.success = (intVal != 0)
        } else {
            self.success = false
        }

        self.message = (try? container.decode(String.self, forKey: .message)) ?? ""

        // Handles single JourneyShareDTO dictionary, or array fallback if returned as [JourneyShareDTO]
        if let single = try? container.decodeIfPresent(JourneyShareDTO.self, forKey: .data) {
            self.data = single
        } else if let array = try? container.decodeIfPresent([JourneyShareDTO].self, forKey: .data), let first = array.first {
            self.data = first
        } else {
            self.data = nil
        }
    }

    func toEntity() -> [JourneyShareEntity] {
        guard let data = data else { return [] }
        return [data.toEntity()]
    }

    func toSingleEntity() -> JourneyShareEntity? {
        data?.toEntity()
    }
}

typealias WatchJourneyShareResponseDTO = WatchingJourneyShareResponseDTO
