//
//  PostMusicCommentRepository.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 1/16/26.
//

import Foundation

protocol PostMusicCommentRepository {
    
    /// 노래 상세 조회 
    func fetchTrackDetail(
        trackId: String
    ) async throws -> Track
    
    /// 음악 코멘트 생성
    /// - Returns: 생성된 postId
    func createPost(
        request: MusicComment
    ) async throws -> Int
}


final class DefaultPostMusicCommentRepository: PostMusicCommentRepository {

    private let service: PostMusicCommentService

    init(service: PostMusicCommentService) {
        self.service = service
    }

    // MARK: - Track Detail

    func fetchTrackDetail(
        trackId: String
    ) async throws -> Track {

        let response = try await service.fetchTrackDetail(trackId: trackId)

        guard
            response.status,
            let item = response.data
        else {
            throw AppError.serverError
        }

        return item.toEntity()
    }

    // MARK: - Create Post

    func createPost(
        request: MusicComment
    ) async throws -> Int {

        let dto = PostMusicCommentRequestDTO(
            trackId: request.track.id,
            songTitle: request.track.title,
            artistName: request.track.artist,
            coverImg: request.track.coverImageURL,
            isrc: request.track.isrc ?? "",
            content: request.content
        )

        let response = try await service.createPost(
            request: dto
        )

        guard
            response.status == true,
            let postId = response.data?.postId
        else {
            throw AppError.serverError
        }

        return postId
    }
}
