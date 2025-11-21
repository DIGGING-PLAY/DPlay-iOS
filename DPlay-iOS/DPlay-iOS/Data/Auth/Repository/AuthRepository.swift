//
//  AuthRepository.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 11/12/25.
//

protocol AuthRepository {
    func loginWithApple(appleIdentityToken: String) async throws -> UserSession
    func refreshAccessToken(refreshToken: String) async throws -> UserSession
    func logout() async throws
}

final class DefaultAuthRepository: AuthRepository {
    
    private let service: AuthService
    
    init(service: AuthService) {
        self.service = service
    }

    func loginWithApple(appleIdentityToken: String) async throws -> UserSession {
        let response = try await service.loginWithApple(appleIdentityToken: appleIdentityToken)
        let entity = response.toEntity()

        return entity
    }
    
    func refreshAccessToken(refreshToken: String) async throws -> UserSession {
        let response = try await service.refreshAccessToken(refreshToken: refreshToken)
        let entity = response.toEntity()

        return entity
    }
    
    func logout() async throws {
        try await service.logout()
    }
}
