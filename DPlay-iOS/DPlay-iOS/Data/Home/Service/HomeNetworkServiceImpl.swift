//
//  HomeService.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 11/16/25.
//

import Foundation

protocol HomeService {
    func fetchHomeFeed() async throws -> HomeFeedResponseDTO
    func like(postId: Int) async throws
    func scrap(postId: Int, isScrapped: Bool) async throws
}

// MARK: - HomeNetworkService

final class HomeNetworkServiceImpl: HomeService {
    
    private let apiService: BaseAPIService
    
    // DI 가능 → 테스트 가능하도록 만듦
    
    init(apiService: BaseAPIService = BaseAPIService()) {
        self.apiService = apiService
    }
    
    // MARK: - Home Feed
    
    func fetchHomeFeed() async throws -> HomeFeedResponseDTO {
        let result = await apiService.request(
            HomeAPI.fetchHomeFeed,
            HomeFeedResponseDTO.self
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
    
    // MARK: - Like
    
    func like(postId: Int) async throws {
        let result = await apiService.request(
            HomeAPI.likePost(postId: postId),
            EmptyDTO.self
        )
        
        switch result {
        case .success:
            return
        case .unauthorized:
            throw AppError.unauthorized
        default:
            throw AppError.serverError
        }
    }
    
    // MARK: - Scrap / Unscrap
    
    func scrap(postId: Int, isScrapped: Bool) async throws {
        let api = isScrapped
        ? HomeAPI.scrap(postId: postId)
        : HomeAPI.unscrap(postId: postId)
        
        let result = await apiService.request(api, EmptyDTO.self)
        
        switch result {
        case .success:
            return
        case .unauthorized:
            throw AppError.unauthorized
        default:
            throw AppError.serverError
        }
    }
}
