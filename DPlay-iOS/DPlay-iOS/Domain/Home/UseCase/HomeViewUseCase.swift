//
//  HomeViewUseCase.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 11/7/25.
//

import Foundation

protocol HomeViewUseCase {
    func getHomeData() async throws -> HomeFeed
    func toggleLike(postId: Int, isLiked: Bool) async throws
    func toggleScrap(postId: Int, isScrapped: Bool) async throws
}

final class DefaultHomeViewUseCase: HomeViewUseCase {

    private let repository: HomeRepository

    init(repository: HomeRepository) {
        self.repository = repository
    }

    // MARK: - Fetch

    func getHomeData() async throws -> HomeFeed {
        try Task.checkCancellation()
        return try await repository.fetchHomeFeed()
    }

    // MARK: - Like

    func toggleLike(postId: Int, isLiked: Bool) async throws {
        try await repository.toggleLike(
            id: postId,
            isLiked: isLiked
        )
    }

    // MARK: - Scrap

    func toggleScrap(postId: Int, isScrapped: Bool) async throws {
        try await repository.toggleScrap(
            id: postId,
            isScrapped: isScrapped
        )
    }
}
