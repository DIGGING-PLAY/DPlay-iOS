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
    func logout() async throws
}
