//
//  MusicDetailUseCase.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 11/18/25.
//

import Foundation

protocol MusicDetailUseCase {
    func getMusicDetail(trackId: String) async throws -> MusicDetail
    func toggleLike(postId: Int, isLiked: Bool) async throws
    func toggleScrap(postId: Int, isScrapped: Bool) async throws
}

final class DefaultMusicDetailUseCase: MusicDetailUseCase {
    private let repository: MusicDetailRepository

    init(repository: MusicDetailRepository) {
        self.repository = repository
    }

    func getMusicDetail(trackId: String) async throws -> MusicDetail {
        let dto = try await repository.fetchMusicDetail(trackId: trackId)
        return dto.toEntity()
    }
    
    func toggleLike(postId: Int, isLiked: Bool) async throws {}
    func toggleScrap(postId: Int, isScrapped: Bool) async throws {}
}

