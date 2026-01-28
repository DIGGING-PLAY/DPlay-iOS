//
//  MusicDetailUseCase.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 11/18/25.
//

import Foundation

protocol MusicCommentDetailUseCase {
    func getMusicDetail(postId: Int) async throws -> MusicCommentDetail
    func toggleLike(postId: Int, isLiked: Bool) async throws
    func toggleScrap(postId: Int, isScrapped: Bool) async throws
    func deletePost(postId: Int) async throws
}

final class DefaultMusicDetailUseCase: MusicCommentDetailUseCase {

    private let repository: MusicCommentDetailRepository

    init(repository: MusicCommentDetailRepository) {
        self.repository = repository
    }

    // MARK: - Fetch Detail

    func getMusicDetail(postId: Int) async throws -> MusicCommentDetail {
        try await repository.fetchMusicDetail(postId: postId)
    }

    // MARK: - Like / Unlike

    func toggleLike(postId: Int, isLiked: Bool) async throws {
        try await repository.toggleLike(
            postId: postId,
            isLiked: isLiked
        )
    }

    // MARK: - Scrap / Unscrap

    func toggleScrap(postId: Int, isScrapped: Bool) async throws {
        try await repository.toggleScrap(
            postId: postId,
            isScrapped: isScrapped
        )
    }

    // MARK: - Delete Post

    func deletePost(postId: Int) async throws {
        try await repository.deletePost(postId: postId)
    }
}
