//
//  AuthRepository.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 11/12/25.
//

import Foundation

protocol AuthRepository {
    func loginWithApple(appleIdentityToken: String) async throws -> UserSession
    func singUp(appleIdentityToken: String, signupRequestBody: SignupRequestDTO, profileImg: Data?) async throws -> UserSession
    func setNotification(pushOn: Bool) async throws
    func logout() async throws
    func withdraw() async throws
    func saveTokens(_ userData: UserSession) throws
    func deleteTokens() throws
}

final class DefaultAuthRepository: AuthRepository {
    
    private let service: AuthService
    
    init(service: AuthService) {
        self.service = service
    }
    
    //MARK: - API Func

    func loginWithApple(appleIdentityToken: String) async throws -> UserSession {
        let response = try await service.loginWithApple(appleIdentityToken: appleIdentityToken)
        
        guard let data = response.data else { throw AppError.emptyData }
        let entity = data.toEntity()

        return entity
    }
    
    func refreshToken() async throws -> UserSession {
        let response = try await service.refreshToken()
        
        guard let data = response.data else { throw AppError.emptyData }
        let entity = data.toEntity()

        return entity
    }
    
    func singUp(appleIdentityToken: String, signupRequestBody: SignupRequestDTO, profileImg: Data?) async throws -> UserSession {
        let response = try await service.singUp(appleIdentityToken: appleIdentityToken, signupRequestBody: signupRequestBody, profileImg: profileImg)
        
        guard let data = response.data else { throw AppError.emptyData }
        let entity = data.toEntity()

        return entity
    }
    
    func setNotification(pushOn: Bool) async throws {
        try await service.setNotification(pushOn: pushOn)
    }
    
    func logout() async throws {
        try await service.logout()
    }
    
    func withdraw() async throws {
        try await service.withdraw()
    }
    
    //MARK: - KeychainManager Func
    
    func saveTokens(_ userData: UserSession) throws {
        KeychainManager.shared.accessToken = userData.accessToken
        KeychainManager.shared.refreshToken = userData.refreshToken
    }
    
    func deleteTokens() throws {
        KeychainManager.shared.clearAll()
    }
}
