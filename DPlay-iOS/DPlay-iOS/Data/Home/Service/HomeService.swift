//
//  HomeService.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 11/16/25.
//

import Foundation

protocol HomeService {
    func fetchHomeFeed() async throws -> HomeFeedResponseDTO
    func like(postId: Int) async throws
    func scrap(postId: Int, isScrapped: Bool) async throws
}

 final class MockHomeService: HomeService {
     func fetchHomeFeed() async throws -> HomeFeedResponseDTO {
         return MockHomeFeed.sample
     }
     
     func like(postId: Int) async throws {}
     func scrap(postId: Int, isScrapped: Bool) async throws {}
 }
