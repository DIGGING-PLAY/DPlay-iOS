//
//  MyPageAPI.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 1/13/26.
//

import Alamofire

enum MyPageAPI {
    case fetchUserProfile(userId: Int)
}

extension MyPageAPI: BaseAPI {
    var path: String {
        switch self {
        case .fetchUserProfile(let userId):
            return "/users/\(userId)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .fetchUserProfile(let userId):
            return .get
        }
    }
    
    var query: Parameters? { nil }
    
    var body: (any Encodable)? { nil }
}
