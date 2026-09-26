//
//  MainRepositoryImpl.swift
//  Networking-Library_iOS
//
//  Created by Dilshad Haidari on 04/09/26.
//
import Domain

final class MainRepositoryImpl: MainRepository {
    
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient = NetworkExecutor1()) {
        self.networkClient = networkClient
    }
    
    func getMyProfile() async throws -> UserResponseEntity {
        let request = GetMeRequest()
        let response: GetMyProfileDTO = try await networkClient.execute(request)
        let entity = response.toEntity()
        
        // Cache user data locally
        let store = UserDefaultsManager.shared
        store.name = entity.user.fullName
        store.email = entity.user.email
        store.phone = entity.user.phone
        store.userId = entity.user.id
        store.setBiometric(enabled: entity.user.biometricEnabled)
        
        return entity
    }
    
    func getGuardianList() async throws -> [GuardianEntity] {
        let request = GetGuardianListRequest()
        let response: GuardianListResponseDTO = try await networkClient.execute(request)
        return response.guardianListEntity()
    }
    
    func acceptGuardianRequest(guardianId: String, code: String) async throws -> GuardianEntity {
        let request = AcceptGuardianRequest(guardianId: guardianId, code: code)
        let response: AcceptGuardianResponseDTO = try await networkClient.execute(request)
        return response.toEntity()
    }
    
    func resendGuardianInviteRequest(guardianId: String) async throws -> DefaultEntity {
        let request = ResendGuardianCodeRequest(guardianId: guardianId)
        let response: DefaultResponseDTO = try await networkClient.execute(request)
        return response.toEntity()
    }
    
    func addGuardian(fullName: String, email: String, phone: String?, relationship: String?) async throws -> GuardianEntity {
        let request = AddGuardianRequest(
            fullName: fullName,
            email: email,
            phone: phone,
            relationshipLabel: relationship
        )
        let response: AddGuardianResponseDTO = try await networkClient.execute(request)
        return response.toEntity()
    }
}
