//
//  AuthService.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 11/22/25.
//

import Foundation

protocol AuthService {
    func loginWithApple(appleIdentityToken: String) async throws -> AuthResponseDTO
    func refreshToken() async throws -> AuthResponseDTO
    func singUp(appleIdentityToken: String, signupRequestBody: SignupRequestDTO, profileImg: Data?) async throws -> AuthResponseDTO
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
    
    func refreshToken() async throws -> AuthResponseDTO {
        let result = await apiService.request(
            AuthAPI.refreshToken,
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
    
    func singUp(appleIdentityToken: String, signupRequestBody: SignupRequestDTO, profileImg: Data?) async throws -> AuthResponseDTO {
        let result = await apiService.request(
            UploadAPI.signup(
                appleIdentityToken: appleIdentityToken,
                signupRequestBody: signupRequestBody,
                profileImg: profileImg
            ),
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
        case .conflict:     throw NicknameError.duplicate
        default:            throw AppError.unknown
        }
    }
    
    func logout() async throws { }
}
