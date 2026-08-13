//
//  File.swift
//  Networking-Library_iOS
//
//  Created by Dilshad Haidari on 08/08/26.
//

import Foundation

public protocol SendOTPUseCaseProtocol: AnyObject {
    func executeUsecase(mobileNo: String, intent: String, fullName: String?) async throws -> SendOTPEntity
}

public final class SendOTPUseCase: SendOTPUseCaseProtocol {
    
    let repository: AuthRepository
    
    public init(repository: AuthRepository) {
        self.repository = repository
    }
    
    public func executeUsecase(mobileNo: String, intent: String, fullName: String?) async throws -> SendOTPEntity {
        return try await repository.sendOTP(mobileNo: mobileNo, intent: intent, fullName: fullName)
    }

}
