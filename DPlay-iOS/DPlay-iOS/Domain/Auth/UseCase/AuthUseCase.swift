//
//  AuthUseCase.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 11/12/25.
//

import UIKit

protocol AuthUseCase {
    func loginWithApple(appleIdentityToken: String) async throws
    func singUp(appleIdentityToken: String, signupRequestBody: SignupRequestDTO, profileImg: UIImage?) async throws
    func setNotification(pushOn: Bool) async throws
    func logout() async throws
    func withdraw(appleAuthorizationCode: String) async throws
    func checkToken() async throws -> AppRoute
}

final class DefaultAuthUseCase: AuthUseCase {
    
    private let authRepository: AuthRepository
    
    init(repository: AuthRepository) {
        self.authRepository = repository
    }
    
    // 애플 로그인
    func loginWithApple(appleIdentityToken: String) async throws {
        let userSession = try await authRepository.loginWithApple(appleIdentityToken: appleIdentityToken)
        try authRepository.saveTokens(userSession)
        UserDefaults.standard.set(userSession.userId, forKey: "userId")
    }
    
    // 회원가입
    func singUp(appleIdentityToken: String, signupRequestBody: SignupRequestDTO, profileImg: UIImage?) async throws {
        let profileImgData = profileImg?.jpegData(compressionQuality: 0.9)
        
        let userSession = try await authRepository.singUp(appleIdentityToken: appleIdentityToken, signupRequestBody: signupRequestBody, profileImg: profileImgData)
        try authRepository.saveTokens(userSession)
        UserDefaults.standard.set(userSession.userId, forKey: "userId")
    }
    
    // 푸시 알림 동의 여부 설정
    func setNotification(pushOn: Bool) async throws {
        try await authRepository.setNotification(pushOn: pushOn)
    }

    // 로그아웃
    func logout() async throws {
        try await authRepository.logout()
        try authRepository.deleteTokens()
        UserDefaults.standard.removeObject(forKey: "userId")
    }
    
    // 회원탈퇴
    func withdraw(appleAuthorizationCode: String) async throws {
        try await authRepository.withdraw(appleAuthorizationCode: appleAuthorizationCode)
        try authRepository.deleteTokens()
        UserDefaults.standard.removeObject(forKey: "userId")
    }
    
    //토큰 유효성 확인을 위한 임의 요청
    func checkToken() async throws -> AppRoute {
        do {
            let _ = try await authRepository.checkToken()
            
            return .mainTabBar
        } catch {
            return .auth
        }
    }
}
