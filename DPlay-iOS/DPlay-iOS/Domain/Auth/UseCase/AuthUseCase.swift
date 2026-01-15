//
//  AuthUseCase.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 11/12/25.
//

import UIKit

protocol AuthUseCase {
    func loginWithApple(appleIdentityToken: String) async throws
    func refreshAccessToken(refreshToken: String) async throws
    func singUp(appleIdentityToken: String, signupRequestBody: SignupRequestDTO, profileImg: UIImage?) async throws
    func logout() async throws
}

final class DefaultAuthUseCase: AuthUseCase {
    
    private let authRepository: AuthRepository
    
    init(repository: AuthRepository) {
        self.authRepository = repository
    }
    
    // 1. 애플 로그인
    func loginWithApple(appleIdentityToken: String) async throws {
        try authRepository.deleteTokens() //키체인 내부의 토큰으로 요청이 날라가는 것을 방지하기 위해 저장된 토큰 삭제 (임시 방편)
        
        let userSession = try await authRepository.loginWithApple(appleIdentityToken: appleIdentityToken)
        try authRepository.saveTokens(userSession)
        
        print("AccessToken: \(KeychainManager.shared.accessToken)")
        print("RefreshToken: \(KeychainManager.shared.refreshToken)")
    }
    
    // 2. 토큰 재발급
    func refreshAccessToken(refreshToken: String) async throws {
        let userSession = try await authRepository.refreshAccessToken(refreshToken: refreshToken)

        print("AccessToken: \(userSession.accessToken)")
        print("RefreshToken: \(userSession.refreshToken)")

        //KeyChainManager 호출하여 토큰 저장 로직 실행
    }
    
    // 3. 회원가입
    func singUp(appleIdentityToken: String, signupRequestBody: SignupRequestDTO, profileImg: UIImage?) async throws {
        let profileImgData = profileImg?.jpegData(compressionQuality: 0.5)
        //업로드 파일 용량으로 인한 413 에러를 반환하는 관계로 임의로 0.5로 지정 (논의 필요)
        
        let userSession = try await authRepository.singUp(appleIdentityToken: appleIdentityToken, signupRequestBody: signupRequestBody, profileImg: profileImgData)
        try authRepository.saveTokens(userSession)
    }

    // 4. 로그아웃
    func logout() async throws {
        try await authRepository.logout()
        try authRepository.deleteTokens()
    }
}
