//
//  File.swift
//  Networking-Library_iOS
//
//  Created by Dilshad Haidari on 04/09/26.
//

import Foundation

public protocol MainRepository {
    
    func getMyProfile() async throws ->  UserResponseEntity
    
    func getGuardianList() async throws ->  [GuardianEntity]
    
    func acceptGuardianRequest(guardianId: String, code: String) async throws -> GuardianEntity
    
    func resendGuardianInviteRequest(guardianId: String) async throws -> DefaultEntity
    
    func addGuardian(fullName: String, email: String, phone: String?, relationship: String?) async throws -> GuardianEntity
}

//CheckedContinuation
