//
//  PostHistoryAPI.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 1/18/26.
//

import Alamofire

enum PostHistoryAPI {
    case fetchMonthlyQuestions(year: Int, month: Int)
    case fetchQuestionPosts(questionId: Int)
}

extension PostHistoryAPI: BaseAPI {
    var path: String {
        switch self {
        case .fetchMonthlyQuestions:
            return "/questions"
        case .fetchQuestionPosts(let questionId):
            return "/posts/\(questionId)"
        }
    }

    var method: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }
    
    var query: Parameters? {
        switch self {
        case .fetchMonthlyQuestions(let year, let month):
            return ["year": year, "month": month]
        default:
            return nil
        }
    }
    
    var body: (any Encodable)? { nil }
}
