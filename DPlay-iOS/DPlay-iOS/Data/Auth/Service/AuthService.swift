//
//  AuthService.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 11/22/25.
//

import Foundation

protocol AuthService {
    func loginWithApple(appleIdentityToken: String) async throws -> AuthDataDTO
    func refreshAccessToken(refreshToken: String) async throws -> AuthDataDTO
    func singUp(nickname: String, image: Data?) async throws -> AuthDataDTO
    func logout() async throws
}

final class MockAuthService: AuthService {
    func loginWithApple(appleIdentityToken: String) async throws -> AuthDataDTO {
        return AuthDataDTO(userId: 0, accessToken: "", refreshToken: "")
    }
    
    func refreshAccessToken(refreshToken: String) async throws -> AuthDataDTO {
        return AuthDataDTO(userId: 0, accessToken: "", refreshToken: "")
    }
    
    func singUp(nickname: String, image: Data?) async throws -> AuthDataDTO {
        if nickname == "중복" {
            throw NicknameError.duplicate
        } else {
            print("회원가입 성공~~~")
            return AuthDataDTO(userId: 0, accessToken: "엑세스 토큰 블라블라", refreshToken: "리프레시 토큰 블라블라")
        }
    }
    
    func logout() async throws { }
}
