//
//  MusicDetailService.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 11/18/25.
//

import Foundation

protocol MusicDetailCommentService {
    func fetchMusicDetail(postId: Int) async throws -> MusicCommentDetailResponseDTO
    func toggleLike(postId: Int, isLiked: Bool) async throws
    func toggleScrap(postId: Int, isScrapped: Bool) async throws
    func deletePost(postId: Int) async throws
}

final class MusicDetailNetworkServiceImpl: MusicDetailCommentService {

    private let apiService: BaseAPIService

    init(apiService: BaseAPIService = BaseAPIService()) {
        self.apiService = apiService
    }

    // MARK: - Fetch Detail

    func fetchMusicDetail(postId: Int) async throws -> MusicCommentDetailResponseDTO {
        let result = await apiService.request(
            MusicCommentDetailAPI.fetchMusicCommentDetail(postId: postId),
            MusicCommentDetailResponseDTO.self
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
            ? PostActionAPI.unlikePost(postId: postId)
            : PostActionAPI.likePost(postId: postId)

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
            ? PostActionAPI.unscrap(postId: postId)
            : PostActionAPI.scrap(postId: postId)

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
    
    // MARK: - Delete Post
    
    func deletePost(postId: Int) async throws {
        let result = await apiService.request(
            MusicCommentDetailAPI.deleteMusicCommentDetail(postId: postId),
            EmptyDTO.self
        )

        switch result {
        case .success:
            return
        case .unauthorized:
            throw AppError.unauthorized
        case .notFound:
            throw AppError.notFound
        default:
            throw AppError.serverError
        }
    }
}
