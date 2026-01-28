//
//  PostHistoryRepository.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 12/31/25.
//

import Foundation

protocol PostHistoryRepository {
    func fetchMonthlyQuestions(year: Int, month: Int) async throws -> [MonthlyQuestion]
    func fetchQuestionPosts(questionId: Int) async throws -> QuestionPosts
}

final class DefaultPostHistoryRepository: PostHistoryRepository {
    
    private let service: PostHistoryService
    
    init(service: PostHistoryService) {
        self.service = service
    }
    
    func fetchMonthlyQuestions(year: Int, month: Int) async throws -> [MonthlyQuestion] {
        let response = try await service.fetchMonthlyQuestions(year: year, month: month)
        guard let data = response.data else { return [MonthlyQuestion]() }
        
        return data.questions.map { $0.toEntity() }
    }
    
    func fetchQuestionPosts(questionId: Int) async throws -> QuestionPosts {
        let response = try await service.fetchQuestionPosts(questionId: questionId)
        
        guard let data = response.data else { throw AppError.emptyData }
        let entity = data.toEntity()
        
        return entity
    }
}
