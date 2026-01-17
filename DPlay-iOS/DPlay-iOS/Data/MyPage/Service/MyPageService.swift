//
//  MyPageService.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 12/2/25.
//

import Foundation

protocol MyPageService {
    func fetchUserProfile(userId: Int) async throws -> MyPageProfileResponseDTO
    func fetchRegisteredTracks(userId: Int) async throws -> MyPageTracksResponseDTO
    func fetchArchiveTracks(userId: Int) async throws -> MyPageTracksResponseDTO
    func updateUserProfile(nickname: String?, profileImg: Data?) async throws
}

final class MyPageServiceImpl: MyPageService {
    private let apiService: BaseAPIService
    
    init(apiService: BaseAPIService = BaseAPIService()) {
        self.apiService = apiService
    }
    
    func fetchUserProfile(userId: Int) async throws -> MyPageProfileResponseDTO {
        let result = await apiService.request(
            MyPageAPI.fetchUserProfile(userId: userId),
            MyPageProfileResponseDTO.self
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
    
    func fetchRegisteredTracks(userId: Int) async throws -> MyPageTracksResponseDTO {
        let result = await apiService.request(
            MyPageAPI.fetchRegisteredTracks(userId: userId),
            MyPageTracksResponseDTO.self
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
    
    func fetchArchiveTracks(userId: Int) async throws -> MyPageTracksResponseDTO {
        let result = await apiService.request(
            MyPageAPI.fetchArchiveTracks(userId: userId),
            MyPageTracksResponseDTO.self
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
    
    func updateUserProfile(nickname: String? = nil, profileImg: Data? = nil) async throws { }
}
