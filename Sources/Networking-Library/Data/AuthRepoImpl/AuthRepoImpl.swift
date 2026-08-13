//
//  AuthRepository.swift
//  CleanArch
//
//  Created by Dilshad Haidari on 11/01/26.
//

import Foundation

class AuthRepoImpl:  AuthRepository {
    
    let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func sendOTP(mobileNo: String, intent: String, fullName: String?) async throws -> SendOTPEntity {
        let request: SendOTPRequest = .init(phone: mobileNo, intent: intent, fullName: fullName)
            let snedOTPResponse : SendOTPDTO = try await networkClient.execute(request)
        return snedOTPResponse.toEntity()
    }
    
    func verifyOTP(mobileNo: String, otp: String) async throws -> OTPVerificationEntity {
        let request: OTPVerificationRequest = .init(phone: mobileNo, otp: otp)
        let response : OTPVerificationDTO = try await networkClient.execute(request)
        return response.toEntity()
    }
    
}
