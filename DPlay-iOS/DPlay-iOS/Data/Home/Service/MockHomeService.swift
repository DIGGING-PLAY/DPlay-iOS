//
//  MockHomeService.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 1/1/26.
//

import Foundation

// MARK: - MockHomeService

final class MockHomeService: HomeService {
    func fetchHomeFeed() async throws -> HomeFeedResponseDTO {
        return MockHomeFeed.sample
    }
    
    func like(postId: Int) async throws {}
    func scrap(postId: Int, isScrapped: Bool) async throws {}
}
