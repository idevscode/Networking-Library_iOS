//
//  GetMyProfileDTO.swift
//  Networking-Library_iOS
//

import Foundation
import Domain

/// DTO for GET /api/v1/user/me
/// Response shape:
/// {
///   "success": 1,
///   "message": "Profile retrieved successfully",
///   "data": { ...user fields directly... },
///   "meta": null,
///   "errors": null
/// }
nonisolated struct GetMyProfileDTO: Decodable, Sendable {
    let success: Bool
    let message: String
    let data: UserDTO         // user fields are directly inside "data"
    let meta: MetaDTO?        // null in profile response
    
    enum CodingKeys: String, CodingKey {
        case success
        case message
        case data
        case meta
    }

    func toEntity() -> UserResponseEntity {
        UserResponseEntity(
            success: success,
            message: message,
            user: data.toEntity(),
            meta: meta?.toEntity()
        )
    }
}
