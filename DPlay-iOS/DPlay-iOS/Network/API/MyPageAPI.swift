//
//  MyPageAPI.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 1/13/26.
//

import Alamofire

enum MyPageAPI {
    case fetchUserProfile(userId: Int)
    case fetchRegisteredTracks(userId: Int, cursor: String?)
    case fetchArchiveTracks(userId: Int, cursor: String?)
}

extension MyPageAPI: BaseAPI {
    var path: String {
        switch self {
        case .fetchUserProfile(let userId):
            return "/users/\(userId)"
        case .fetchRegisteredTracks(let userId, _):
            return "/users/\(userId)/posts"
        case .fetchArchiveTracks(let userId, _):
            return "/users/\(userId)/scraps"
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
        case .fetchRegisteredTracks(_, let cursor):
            var params: Parameters = [
                "limit": 20,
            ]
            if let cursor {
                params["cursor"] = cursor
            }
            return params
        case .fetchArchiveTracks(_, let cursor):
            var params: Parameters = [
                "limit": 15,
            ]
            if let cursor {
                params["cursor"] = cursor
            }
            return params
        default:
            return nil
        }
    }
    
    var body: (any Encodable)? { nil }
}
