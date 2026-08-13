//
//  AuthRepository.swift
//  Networking-Library_iOS
//
//  Created by Dilshad Haidari on 08/08/26.
//


public protocol AuthRepository {
    
    func sendOTP(
        mobileNo: String,
        intent: String,
        fullName: String?
    ) async throws  -> SendOTPEntity
    
    func verifyOTP(
        mobileNo: String,
        otp: String
    ) async throws -> OTPVerificationEntity
}
