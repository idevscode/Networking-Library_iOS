//
//  OTPVerificationUsecase.swift
//  Networking-Library_iOS
//
//  Created by Dilshad Haidari on 09/08/26.
//

public protocol OTPVerificationUsecaseProtocol: AnyObject {
    
    func verifuOTP(otp: String, phone: String) async throws -> OTPVerificationEntity
}

final class OTPVerificationUsecase: OTPVerificationUsecaseProtocol {
    
    let repository: AuthRepository
    
    init(repository: AuthRepository) {
        self.repository = repository
    }
    
    func verifuOTP(otp: String, phone: String) async throws -> OTPVerificationEntity {
        return try await repository.verifyOTP(mobileNo: phone, otp: otp)
    }
}
