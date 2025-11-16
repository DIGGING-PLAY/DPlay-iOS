//
//  AuthRepository.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 11/12/25.
//

protocol AuthRepository {
    func loginWithApple(appleIdentityToken: String) async throws -> User
    func refreshAccessToken(refreshToken: String) async throws -> AuthToken
    func logout() async throws
}

final class DefaultAuthRepository: AuthRepository {
    func loginWithApple(appleIdentityToken: String) async throws -> User {
        return User(userId: 0, userTokens: AuthToken(accessToken: "", refreshToken: ""))
    }
    
    func refreshAccessToken(refreshToken: String) async throws -> AuthToken {
        return AuthToken(accessToken: "", refreshToken: "")
    }
    
    func logout() {
        print("로그아웃")
    }
}
