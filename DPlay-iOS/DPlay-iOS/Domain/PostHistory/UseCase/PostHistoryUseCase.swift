//
//  PostHistoryUseCase.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 12/31/25.
//

import Foundation

protocol PostHistoryUseCase {
    func getMonthlyQuestions(year: Int, month: Int) async throws -> [MonthlyQuestion]
    func getQuestionPosts(questionId: Int) async throws -> QuestionPosts
}

final class DefaultPostHistoryUseCase: PostHistoryUseCase {
    
    private let repository: PostHistoryRepository
    
    init(repository: PostHistoryRepository) {
        self.repository = repository
    }
    
    func getMonthlyQuestions(year: Int, month: Int) async throws -> [MonthlyQuestion] {
        let data = try await repository.fetchMonthlyQuestions(year: year, month: month)
        
        return data
    }
    
    func getQuestionPosts(questionId: Int) async throws -> QuestionPosts {
        let data = try await repository.fetchQuestionPosts(questionId: questionId)
        
        return data
    }
}

