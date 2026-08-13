//
//  SendOTPDTO.swift
//  Networking-Library_iOS
//
//  Created by Dilshad Haidari on 08/08/26.
//

/*
 {
   "success": true,
   "message": "OTP sent to your mobile number.",
   "data": null,
   "debug_otp": "728544"
 }
 */

struct SendOTPDTO: Codable {
    let success: Bool
    let message: String
    let data: String?
    let debugOTP: String
    
    
    enum CodingKeys: String, CodingKey {
        case success
        case message
        case data
        case debugOTP = "debug_otp"
    }
    
    func toEntity() -> SendOTPEntity {
        SendOTPEntity(
            success: success,
            message: message,
            data: data,
            debugOTP: debugOTP
        )
    }
}
