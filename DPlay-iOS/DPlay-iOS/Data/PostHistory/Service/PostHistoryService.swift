//
//  PostHistoryService.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 12/31/25.
//

import Foundation

protocol PostHistoryService {
    func fetchMonthluQuestions(year: Int, month: Int) async throws -> MonthlyQuestionsResponseDTO
}

final class MockPostHistoryService: PostHistoryService {
    func fetchMonthluQuestions(year: Int, month: Int) async throws -> MonthlyQuestionsResponseDTO {
        return MockMonthlyQuestion.questionsSample
    }
}
