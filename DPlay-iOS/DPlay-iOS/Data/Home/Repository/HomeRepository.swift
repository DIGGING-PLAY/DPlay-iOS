//
//  HomeRepository.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 11/7/25.
//

import Foundation

protocol HomeRepository {
    func fetchHomeFeed() async throws -> HomeFeed
    func toggleLike(id: Int, isLiked: Bool) async throws
    func toggleScrap(id: Int, isScrapped: Bool) async throws
}

final class DefaultHomeRepository: HomeRepository {

    private let service: HomeService

    init(service: HomeService) {
        self.service = service
    }

    // MARK: - Home Feed

    func fetchHomeFeed() async throws -> HomeFeed {
        let responseDTO = try await service.fetchHomeFeed()

        guard let data = responseDTO.data else {
            throw AppError.emptyData
        }

        return data.toEntity()
    }

    // MARK: - Like / Unlike

    func toggleLike(id: Int, isLiked: Bool) async throws {
        try await service.toggleLike(
            postId: id,
            isLiked: isLiked
        )
    }

    // MARK: - Scrap / Unscrap

    func toggleScrap(id: Int, isScrapped: Bool) async throws {
        try await service.toggleScrap(
            postId: id,
            isScrapped: isScrapped
        )
    }
}
