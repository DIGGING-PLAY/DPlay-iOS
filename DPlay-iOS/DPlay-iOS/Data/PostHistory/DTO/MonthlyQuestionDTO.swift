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
