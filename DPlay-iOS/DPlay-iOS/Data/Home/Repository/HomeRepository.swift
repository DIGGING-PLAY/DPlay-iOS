//
//  HomeRepository.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 11/7/25.
//

import Foundation

protocol HomeRepository {
    func fetchTodayQuestion() async throws -> Question
    func fetchTodayRecommendations() async throws -> [Recommendation]
    func likeRecommendation(id: Int) async throws
    func scrapRecommendation(id: Int) async throws
    func unscrapRecommendation(id: Int) async throws
}

final class DefaultHomeRepository: HomeRepository {
    init() {}
    
    /*
     func fetchTodayQuestion() async throws -> Question {
            let dto = try await service.getTodayQuestion()
            return dto.toDomain()
     }
     */
    func fetchTodayQuestion() async throws -> Question {
        return MockQuestions.today
    }
    
    func fetchTodayRecommendations() async throws -> [Recommendation] {
        return MockRecommendations.today
    }
    
    func likeRecommendation(id: Int) async throws {
        print("\(id)번 추천글 좋아요 처리됨 (Mock)")
    }
    
    func scrapRecommendation(id: Int) async throws {
        print("\(id)번 추천글 스크랩 처리됨 (Mock)")
    }
    
    func unscrapRecommendation(id: Int) async throws {
        print("\(id)번 추천글 스크랩 해제됨 (Mock)")
    }
}
