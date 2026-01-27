//
//  PostHistoryService.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 12/31/25.
//

import Foundation

protocol PostHistoryService {
    func fetchMonthlyQuestions(year: Int, month: Int) async throws -> MonthlyQuestionsResponseDTO
    func fetchQuestionPosts(questionId: Int) async throws -> QuestionPostsResponseDTO
}

final class PostHistoryServiceImpl: PostHistoryService {
    private let apiService: BaseAPIService
    
    init(apiService: BaseAPIService = BaseAPIService()) {
        self.apiService = apiService
    }
    
    func fetchMonthlyQuestions(year: Int, month: Int) async throws -> MonthlyQuestionsResponseDTO {
        let result = await apiService.request(
            PostHistoryAPI.fetchMonthlyQuestions(year: year, month: month),
            MonthlyQuestionsResponseDTO.self
        )
        
        switch result {
        case .success(let dto):
            guard let dto = dto else {
                throw AppError.emptyData
            }
            return dto
            
        case .unauthorized: throw AppError.unauthorized
        case .notFound:     throw AppError.notFound
        case .decodeError:  throw AppError.decodeError
        case .badRequest:   throw AppError.badRequest
        case .serverError:  throw AppError.serverError
        case .networkFail:  throw AppError.networkFail
        default:            throw AppError.unknown
        }
    }
    
    func fetchQuestionPosts(questionId: Int) async throws -> QuestionPostsResponseDTO {
        let result = await apiService.request(
            PostHistoryAPI.fetchQuestionPosts(questionId: questionId),
            QuestionPostsResponseDTO.self
        )
        
        switch result {
        case .success(let dto):
            guard let dto = dto else {
                throw AppError.emptyData
            }
            return dto
            
        case .unauthorized: throw AppError.unauthorized
        case .notFound:     throw AppError.notFound
        case .decodeError:  throw AppError.decodeError
        case .badRequest:   throw AppError.badRequest
        case .serverError:  throw AppError.serverError
        case .networkFail:  throw AppError.networkFail
        default:            throw AppError.unknown
        }
    }
}
