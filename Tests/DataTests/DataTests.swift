//
//  DataTests.swift
//  Networking-Library_iOS
//

import XCTest
import CryptoKit
@testable import Data

final class DataTests: XCTestCase {
    func testSPKI() {
        let privateKey = P256.Signing.PrivateKey()
        let publicKey = privateKey.publicKey
        let x963 = publicKey.x963Representation
        
        // P-256 SPKI Header (26 bytes)
        let spkiHeader = Data([
            0x30, 0x59, // SEQUENCE, 89 bytes
            0x30, 0x13, // SEQUENCE (AlgorithmIdentifier), 19 bytes
            0x06, 0x07, 0x2a, 0x86, 0x48, 0xce, 0x3d, 0x02, 0x01, // OID 1.2.840.10045.2.1 (id-ecPublicKey)
            0x06, 0x08, 0x2a, 0x86, 0x48, 0xce, 0x3d, 0x03, 0x01, 0x07, // OID 1.2.840.10045.3.1.7 (secp256r1)
            0x03, 0x42, 0x00 // BIT STRING, 66 bytes (0 unused bits)
        ])
        
        let spkiDer = spkiHeader + x963
        XCTAssertEqual(spkiDer.count, 91)
        print("SPKI Base64: \(spkiDer.base64EncodedString())")
    }

    func testRegisterAccountDTODecodingWithActualApiResponse() throws {
        let jsonString = """
        {
            "data": {
                "user": {
                    "biometric_enabled": 0,
                    "created_at": "2026-09-14T01:02:35.870308",
                    "email": "Mail2dilshadali@gmail.com",
                    "emergency_contacts": [
                        {
                            "id": "34f530e6-45a4-4478-b49d-371f01aa5ae6",
                            "name": "Emergency Contact 1",
                            "phone": "+917827543536",
                            "priority": 1,
                            "relationship_label": "Primary Contact"
                        }
                    ],
                    "full_name": "Mani Raj",
                    "gender": "Male",
                    "id": "13ecd4bf-92b2-4345-a721-388a328894cf",
                    "phone": "+919569569560",
                    "phone_verified": 0,
                    "updated_at": "2026-09-14T01:02:35.870319"
                }
            },
            "errors": null,
            "message": "Account created! Please verify your phone number with the OTP sent to your mobile.",
            "meta": {
                "debug_otp": 389212
            },
            "success": true
        }
        """

        let data = jsonString.data(using: .utf8)!
        let dto = try JSONDecoder().decode(RegisterAccountDTO.self, from: data)

        XCTAssertTrue(dto.success)
        XCTAssertEqual(dto.message, "Account created! Please verify your phone number with the OTP sent to your mobile.")
        XCTAssertEqual(dto.data.user.id, "13ecd4bf-92b2-4345-a721-388a328894cf")
        XCTAssertEqual(dto.data.user.fullName, "Mani Raj")
        XCTAssertEqual(dto.data.user.email, "Mail2dilshadali@gmail.com")
        XCTAssertEqual(dto.data.user.phone, "+919569569560")
        XCTAssertEqual(dto.data.user.gender, "Male")
        XCTAssertFalse(dto.data.user.biometricEnabled)
        XCTAssertFalse(dto.data.user.phoneVerified)
        XCTAssertEqual(dto.data.user.emergencyContacts.count, 1)
        XCTAssertEqual(dto.meta?.debugOtp, "389212")

        let entity = dto.toEntity()
        XCTAssertTrue(entity.success)
        XCTAssertEqual(entity.user.fullName, "Mani Raj")
        XCTAssertEqual(entity.metaEntity?.otp, "389212")
    }

    func testRegisterAccountDTODecodingWithBooleansAndNullMeta() throws {
        let jsonString = """
        {
            "data": {
                "user": {
                    "biometric_enabled": true,
                    "created_at": "2026-09-14T01:02:35.870308",
                    "email": "test@example.com",
                    "emergency_contacts": [],
                    "full_name": "Test User",
                    "gender": "Female",
                    "id": "abc-123",
                    "phone": "+911234567890",
                    "phone_verified": true
                }
            },
            "errors": null,
            "message": "Success",
            "meta": null,
            "success": true
        }
        """

        let data = jsonString.data(using: .utf8)!
        let dto = try JSONDecoder().decode(RegisterAccountDTO.self, from: data)

        XCTAssertTrue(dto.success)
        XCTAssertTrue(dto.data.user.biometricEnabled)
        XCTAssertTrue(dto.data.user.phoneVerified)
        XCTAssertNil(dto.meta)

        let entity = dto.toEntity()
        XCTAssertNil(entity.metaEntity?.otp)
    }

    func testAddGuardianResponseDTODecoding() throws {
        let jsonString = """
        {
          "success": true,
          "message": "Request completed successfully",
          "data": {
            "id": "g-123",
            "full_name": "Rohan Sharma",
            "email": "rohan@example.com",
            "phone": "+919876543213",
            "relationship_label": "Brother",
            "status": "invited",
            "invited_at": "2026-09-14T02:19:09.311Z",
            "created_at": "2026-09-14T02:19:09.311Z",
            "updated_at": "2026-09-14T02:19:09.311Z"
          },
          "meta": {},
          "errors": {}
        }
        """

        let data = jsonString.data(using: .utf8)!
        let dto = try JSONDecoder().decode(AddGuardianResponseDTO.self, from: data)

        XCTAssertTrue(dto.success)
        XCTAssertEqual(dto.message, "Request completed successfully")
        XCTAssertEqual(dto.data.id, "g-123")
        XCTAssertEqual(dto.data.fullName, "Rohan Sharma")
        XCTAssertEqual(dto.data.email, "rohan@example.com")
        XCTAssertEqual(dto.data.phone, "+919876543213")
        XCTAssertEqual(dto.data.relationshipLabel, "Brother")
        XCTAssertEqual(dto.data.status, "invited")

        let entity = dto.toEntity()
        XCTAssertEqual(entity.id, "g-123")
        XCTAssertEqual(entity.fullName, "Rohan Sharma")
        XCTAssertEqual(entity.email, "rohan@example.com")
        XCTAssertEqual(entity.phone, "+919876543213")
        XCTAssertEqual(entity.relationship, "Brother")
        XCTAssertEqual(entity.status, "invited")
    }

    func testAcceptGuardianResponseDTODecoding() throws {
        let jsonString = """
        {
          "success": true,
          "message": "Request completed successfully",
          "data": {
            "id": "guardian-456",
            "full_name": "Aanya Sharma",
            "email": "aanya@example.com",
            "phone": "+14155550188",
            "relationship_label": "Mother",
            "status": "invited",
            "invited_at": "2026-09-25T03:51:11.277Z",
            "created_at": "2026-09-25T03:51:11.277Z",
            "updated_at": "2026-09-25T03:51:11.277Z"
          },
          "meta": {},
          "errors": {}
        }
        """

        let data = jsonString.data(using: .utf8)!
        let dto = try JSONDecoder().decode(AcceptGuardianResponseDTO.self, from: data)

        XCTAssertTrue(dto.success)
        XCTAssertEqual(dto.message, "Request completed successfully")
        XCTAssertEqual(dto.data.id, "guardian-456")
        XCTAssertEqual(dto.data.fullName, "Aanya Sharma")
        XCTAssertEqual(dto.data.email, "aanya@example.com")
        XCTAssertEqual(dto.data.phone, "+14155550188")
        XCTAssertEqual(dto.data.relationshipLabel, "Mother")
        XCTAssertEqual(dto.data.status, "invited")

        let entity = dto.toEntity()
        XCTAssertEqual(entity.id, "guardian-456")
        XCTAssertEqual(entity.fullName, "Aanya Sharma")
        XCTAssertEqual(entity.email, "aanya@example.com")
        XCTAssertEqual(entity.phone, "+14155550188")
        XCTAssertEqual(entity.relationship, "Mother")
        XCTAssertEqual(entity.status, "invited")
    }
}
