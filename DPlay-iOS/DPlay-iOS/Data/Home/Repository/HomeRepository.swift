//
//  HomeRepository.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 11/7/25.
//

import Foundation

protocol HomeRepository {
    func fetchHomeFeed() async throws -> HomeFeed
    func updateLike(id: Int) async throws
    func updateScrap(id: Int, isScrapped: Bool) async throws
}

final class DefaultHomeRepository: HomeRepository {

    private let service: HomeService

    init(service: HomeService) {
        self.service = service
    }

    func fetchHomeFeed() async throws -> HomeFeed {
        let responseDTO = try await service.fetchHomeFeed()
        return responseDTO.data.toEntity()
    }

    func updateLike(id: Int) async throws {
        try await service.like(postId: id)
    }

    func updateScrap(id: Int, isScrapped: Bool) async throws {
        try await service.scrap(postId: id, isScrapped: isScrapped)
    }
}
