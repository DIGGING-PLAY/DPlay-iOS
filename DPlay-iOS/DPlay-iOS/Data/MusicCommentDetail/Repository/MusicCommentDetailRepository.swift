//
//  MusicDetailRepository.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 11/18/25.
//

import Foundation

protocol MusicCommentDetailRepository {
    func fetchMusicDetail(postId: Int) async throws -> MusicCommentDetail
    func toggleLike(postId: Int, isLiked: Bool) async throws
    func toggleScrap(postId: Int, isScrapped: Bool) async throws
    func deletePost(postId: Int) async throws
}

final class DefaultCommentMusicDetailRepository: MusicCommentDetailRepository {

    private let service: MusicDetailCommentService

    init(service: MusicDetailCommentService) {
        self.service = service
    }

    // MARK: - Fetch Detail

    func fetchMusicDetail(postId: Int) async throws -> MusicCommentDetail {
        let response = try await service.fetchMusicDetail(postId: postId)
        guard let data = response.data else {
            throw AppError.emptyData
        }
        return data.toEntity()
    }

    // MARK: - Like / Unlike

    func toggleLike(postId: Int, isLiked: Bool) async throws {
        try await service.toggleLike(
            postId: postId,
            isLiked: isLiked
        )
    }

    // MARK: - Scrap / Unscrap

    func toggleScrap(postId: Int, isScrapped: Bool) async throws {
        try await service.toggleScrap(
            postId: postId,
            isScrapped: isScrapped
        )
    }

    // MARK: - Delete

    func deletePost(postId: Int) async throws {
        try await service.deletePost(postId: postId)
    }
}
