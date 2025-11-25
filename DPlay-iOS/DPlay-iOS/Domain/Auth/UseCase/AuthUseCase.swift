//
//  AuthUseCase.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 11/12/25.
//

import Foundation

protocol AuthUseCase {
    func loginWithApple(appleIdentityToken: String) async throws
    func refreshAccessToken(refreshToken: String) async throws
    func singUp(nickname: String, image: Data?) async throws
    func logout() async throws
}

final class DefaultAuthUseCase: AuthUseCase {
    
    private let authRepository: AuthRepository
    
    init(repository: AuthRepository) {
        self.authRepository = repository
    }
    
    // 1. 애플 로그인
    func loginWithApple(appleIdentityToken: String) async throws {
        let userSession = try await authRepository.loginWithApple(appleIdentityToken: appleIdentityToken)
        
        print("AccessToken: \(userSession.accessToken)")
        print("RefreshToken: \(userSession.refreshToken)")

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

        print("AccessToken: \(userSession.accessToken)")
        print("RefreshToken: \(userSession.refreshToken)")

        //KeyChainManager 호출하여 토큰 저장 로직 실행
    }
    
    // 3. 회원가입
    func singUp(nickname: String, image: Data?) async throws {
        let userSession = try await authRepository.singUp(nickname: nickname, image: image)
        
        print("AccessToken: \(userSession.accessToken)")
        print("RefreshToken: \(userSession.refreshToken)")
        
        //KeyChainManager 호출하여 토큰 저장 로직 실행
    }

    // 4. 로그아웃
    func logout() async throws {
        try await authRepository.logout()
    }

}
