//
//  PostHistoryAPI.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 1/18/26.
//

import Alamofire

enum PostHistoryAPI {
    case fetchMonthlyQuestions(year: Int, month: Int)
    case fetchQuestionPosts(questionId: Int, cursor: String?)
}

extension PostHistoryAPI: BaseAPI {
    var path: String {
        switch self {
        case .fetchMonthlyQuestions:
            return "/questions"
        case .fetchQuestionPosts(let questionId, _):
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
        case .fetchQuestionPosts(_, let cursor):
            var params: Parameters = [
                "limit": 20,
            ]
            if let cursor {
                params["cursor"] = cursor
            }
            return params
        }
    }
    
    var body: (any Encodable)? { nil }
}
