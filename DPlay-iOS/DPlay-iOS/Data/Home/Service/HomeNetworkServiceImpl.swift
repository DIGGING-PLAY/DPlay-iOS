//
//  HomeService.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 11/16/25.
//

import Foundation

protocol HomeService {
    func fetchHomeFeed() async throws -> HomeFeedResponseDTO
    func toggleLike(postId: Int, isLiked: Bool) async throws
    func toggleScrap(postId: Int, isScrapped: Bool) async throws
}

// MARK: - HomeNetworkService

final class HomeNetworkServiceImpl: HomeService {

    private let apiService: BaseAPIService

    // DI 가능 → 테스트 가능
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
            guard let dto else {
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

    // MARK: - Like / Unlike

    func toggleLike(postId: Int, isLiked: Bool) async throws {
        let api = isLiked
            ? HomeAPI.unlikePost(postId: postId)
            : HomeAPI.likePost(postId: postId)

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

    // MARK: - Scrap / Unscrap

    func toggleScrap(postId: Int, isScrapped: Bool) async throws {
        let api = isScrapped
            ? HomeAPI.unscrap(postId: postId)
            : HomeAPI.scrap(postId: postId)

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
