//
//  AuthUseCase.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 11/12/25.
//

protocol AuthUseCase {
    func loginWithApple(appleIdentityToken: String) async throws -> UserSession
    func refreshAccessToken(refreshToken: String) async throws -> AuthToken
    func logout() async throws
}

final class DefaultAuthUseCase: AuthUseCase {
    
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    // 1. 애플 로그인
    func loginWithApple(appleIdentityToken: String) async throws -> UserSession {
        return try await authRepository.loginWithApple(appleIdentityToken: appleIdentityToken)
    }
    
    // 2. 토큰 재발급
    func refreshAccessToken(refreshToken: String) async throws -> AuthToken {
        return try await authRepository.refreshAccessToken(refreshToken: refreshToken)
    }
    
    // 3.로그아웃
    func logout() async throws {
        try await authRepository.logout()
    }

}
