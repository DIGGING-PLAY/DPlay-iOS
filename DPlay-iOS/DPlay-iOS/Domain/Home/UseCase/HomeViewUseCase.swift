//
//  HomeViewUseCase.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 11/7/25.
//

import Foundation

// MARK: - Protocol

protocol HomeViewUseCase {
    func fetchTodayQuestion() async throws -> Question
    func fetchTodayRecommendations(hasUserPosted: Bool) async throws -> [Recommendation]
    func likeRecommendation(id: Int) async throws
    func scrapRecommendation(id: Int, isScrapped: Bool) async throws
}

final class DefaultHomeViewUseCase: HomeViewUseCase {
    
    private let homeRepository: HomeRepository
    
    init(homeRepository: HomeRepository) {
        self.homeRepository = homeRepository
    }
    
    // 1. 오늘의 질문 가져오기
    func fetchTodayQuestion() async throws -> Question {
        return try await homeRepository.fetchTodayQuestion()
    }
    
    // 2. 오늘의 추천글 가져오기 (비즈니스 규칙 포함)
    func fetchTodayRecommendations(hasUserPosted: Bool) async throws -> [Recommendation] {
        let allRecommendations = try await homeRepository.fetchTodayRecommendations()
        
        // “글을 작성하지 않으면 3개만 보이게 한다” 규칙 (애플리케이션 특화 업무 규칙)
        if hasUserPosted {
            return allRecommendations
        } else {
            return Array(allRecommendations.prefix(3))
        }
    }
    
    // 3. 좋아요 등록
    func likeRecommendation(id: Int) async throws {
        try await homeRepository.likeRecommendation(id: id)
    }
    
    // 4. 스크랩 등록 / 해제
    func scrapRecommendation(id: Int, isScrapped: Bool) async throws {
        if isScrapped {
            try await homeRepository.unscrapRecommendation(id: id)
        } else {
            try await homeRepository.scrapRecommendation(id: id)
        }
    }
}
