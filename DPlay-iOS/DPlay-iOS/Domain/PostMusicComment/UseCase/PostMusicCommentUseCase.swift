//
//  PostMusicCommentUseCase.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 1/16/26.
//

import Foundation

protocol PostMusicCommentUseCase {

    /// 노래 상세 조회
    func fetchTrackDetail(
         trackId: String
     ) async throws -> Track

    /// 음악 코멘트 생성
    /// - Returns: 생성된 postId
    func createPost(
        comment: MusicComment
    ) async throws -> Int
}

final class DefaultPostMusicCommentUseCase: PostMusicCommentUseCase {

    private let repository: PostMusicCommentRepository

    init(repository: PostMusicCommentRepository) {
        self.repository = repository
    }

    // MARK: - Track Detail

    func fetchTrackDetail(
        trackId: String
    ) async throws -> Track {
        try await repository.fetchTrackDetail(trackId: trackId)
    }

    // MARK: - Create Post

    func createPost(
        comment: MusicComment
    ) async throws -> Int {
        try await repository.createPost(request: comment)
    }
}
