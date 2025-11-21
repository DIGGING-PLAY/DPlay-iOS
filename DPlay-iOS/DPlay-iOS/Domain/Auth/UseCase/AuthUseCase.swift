//
//  AuthUseCase.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 11/12/25.
//

protocol AuthUseCase {
    func loginWithApple(appleIdentityToken: String) async throws
    func refreshAccessToken(refreshToken: String) async throws
    func logout() async throws
}

final class DefaultAuthUseCase: AuthUseCase {
    
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    // 1. 애플 로그인
    func loginWithApple(appleIdentityToken: String) async throws {
        let userSession = try await authRepository.loginWithApple(appleIdentityToken: appleIdentityToken)
        
//        KeyChainManager 호출하여 토큰 저장 로직 실행
//        예시)
//        try KeyChainManager.save(
//            accessToken: userSession.accessToken,
//            refreshToken: userSession..refreshToken
//        )
    }
    
    // 2. 토큰 재발급
    func refreshAccessToken(refreshToken: String) async throws {
        let userSession = try await authRepository.refreshAccessToken(refreshToken: refreshToken)
        
        //KeyChainManager 호출하여 토큰 저장 로직 실행
    }
    
    // 3.로그아웃
    func logout() async throws {
        try await authRepository.logout()
    }

}
