//
//  MyPageAPI.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 1/13/26.
//

import Alamofire

enum MyPageAPI {
    case fetchUserProfile(userId: Int)
    case fetchRegisteredTracks(userId: Int)
    case fetchArchiveTracks(userId: Int)
}

extension MyPageAPI: BaseAPI {
    var path: String {
        switch self {
        case .fetchUserProfile(let userId):
            return "/users/\(userId)"
        case .fetchRegisteredTracks(let userId):
            return "/users/\(userId)/posts"
        case .fetchArchiveTracks(let userId):
            return "/users/\(userId)/scraps"
        }
    }

    var method: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }
    
    var query: Parameters? { nil }
    
    var body: (any Encodable)? { nil }
}
