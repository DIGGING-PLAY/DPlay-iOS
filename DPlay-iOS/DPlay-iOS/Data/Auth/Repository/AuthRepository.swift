//
//  AuthRepository.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 11/12/25.
//

import Foundation

protocol AuthRepository {
    func loginWithApple(appleIdentityToken: String) async throws -> UserSession
    func refreshAccessToken(refreshToken: String) async throws -> UserSession
    func singUp(appleIdentityToken: String, signupRequestBody: SignupRequestDTO, profileImg: Data?) async throws -> UserSession
    func logout() async throws
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
    
    func refreshAccessToken(refreshToken: String) async throws -> UserSession {
        let response = try await service.refreshAccessToken(refreshToken: refreshToken)
        let entity = response.toEntity()

        return entity
    }
    
    func singUp(appleIdentityToken: String, signupRequestBody: SignupRequestDTO, profileImg: Data?) async throws -> UserSession {
        let response = try await service.singUp(appleIdentityToken: appleIdentityToken, signupRequestBody: signupRequestBody, profileImg: profileImg)
        
        guard let data = response.data else { throw AppError.emptyData }
        let entity = data.toEntity()

        return entity
    }
    
    func logout() async throws {
        try await service.logout()
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
