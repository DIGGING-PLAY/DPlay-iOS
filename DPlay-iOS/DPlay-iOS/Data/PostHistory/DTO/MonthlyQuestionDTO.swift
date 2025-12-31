//
//  MonthlyQuestionDTO.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 12/30/25.
//

import Foundation

typealias MonthlyQuestionsResponseDTO = BaseResponseDTO<MonthlyQuestionsDataDTO>

struct MonthlyQuestionsDataDTO: Decodable {
    let questions: [MonthlyQuestionDTO]
}

struct MonthlyQuestionDTO: Decodable {
    let day: String
    let questionId: Int
    let title: String
}

// MARK: - DTO to Entity

extension MonthlyQuestionDTO {
    func toEntity() -> MonthlyQuestion {
        MonthlyQuestion(
            id: questionId,
            day: day,
            title: title
        )
    }
}
