//
//  AuthService.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 11/22/25.
//

import Foundation

protocol AuthService {
    func loginWithApple(appleIdentityToken: String) async throws -> AuthResponseDTO
    func refreshAccessToken(refreshToken: String) async throws -> AuthDataDTO
    func singUp(nickname: String, image: Data?) async throws -> AuthDataDTO
    func logout() async throws
}

final class AuthServiceImpl: AuthService {
    
    private let apiService: BaseAPIService
        
    init(apiService: BaseAPIService = BaseAPIService()) {
        self.apiService = apiService
    }
    
    func loginWithApple(appleIdentityToken: String) async throws -> AuthResponseDTO {
        let result = await apiService.request(
            AuthAPI.login(appleIdentityToken: appleIdentityToken),
            AuthResponseDTO.self
        )
        
        switch result {
        case .success(let dto):
            guard let dto = dto else {
                throw AppError.emptyData
            }
            return dto
            
        case .unauthorized: throw AppError.unauthorized
        case .notFound:     throw AppError.notFound
        case .decodeError:  throw AppError.decodeError
        case .badRequest:   throw AppError.badRequest
        case .serverError:  throw AppError.serverError
        case .networkFail:  throw AppError.networkFail
        default:            throw AppError.unknown
        }
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
