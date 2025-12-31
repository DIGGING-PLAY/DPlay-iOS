//
//  PostHistoryRepository.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 12/31/25.
//

import Foundation

protocol PostHistoryRepository {
    func fetchMonthluQuestions(year: Int, month: Int) async throws -> [MonthlyQuestion]
}

final class DefaultPostHistoryRepository: PostHistoryRepository {
    
    private let service: PostHistoryService
    
    init(service: PostHistoryService) {
        self.service = service
    }
    
    func fetchMonthluQuestions(year: Int, month: Int) async throws -> [MonthlyQuestion] {
        let response = try await service.fetchMonthluQuestions(year: year, month: month)
        guard let data = response.data else { return [MonthlyQuestion]() }
        
        return data.questions.map { $0.toEntity() }
    }
}
