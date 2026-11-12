//
//  JourneySharesResponseDTO.swift
//  Data
//
//  Created by Dilshad Haidari on 18/10/26.
//

import Foundation
import Domain

nonisolated struct JourneySharesResponseDTO: Decodable, Sendable {
    let success: Bool
    let message: String
    let data: [JourneyShareDTO]?

    enum CodingKeys: String, CodingKey {
        case success
        case message
        case data
    }

    init(
        success: Bool = true,
        message: String = "",
        data: [JourneyShareDTO]? = nil
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

        // Supports both array of shares and single share dictionary
        if let array = try? container.decodeIfPresent([JourneyShareDTO].self, forKey: .data) {
            self.data = array
        } else if let single = try? container.decodeIfPresent(JourneyShareDTO.self, forKey: .data) {
            self.data = [single]
        } else {
            self.data = nil
        }
    }

    func toEntity() -> [JourneyShareEntity] {
        data?.map { $0.toEntity() } ?? []
    }
}

typealias GetJourneySharesResponseDTO = JourneySharesResponseDTO
