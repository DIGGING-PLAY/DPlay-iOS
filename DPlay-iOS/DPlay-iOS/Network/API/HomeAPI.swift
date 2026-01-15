//
//  HomeAPI.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 12/1/25.
//

import Foundation

import Alamofire
// HomeAPI.swift

import Alamofire

enum HomeAPI {
    case fetchHomeFeed
    case likePost(postId: Int)
    case unlikePost(postId: Int)
    case scrap(postId: Int)
    case unscrap(postId: Int)
}

extension HomeAPI: BaseAPI {

    var path: String {
        switch self {
        case .fetchHomeFeed:
            return "/posts/today"

        case .likePost(let postId),
             .unlikePost(let postId):
            return "/posts/\(postId)/likes"

        case .scrap(let postId),
             .unscrap(let postId):
            return "/posts/\(postId)/scraps"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .fetchHomeFeed:
            return .get

        case .likePost:
            return .post

        case .unlikePost:
            return .delete

        case .scrap:
            return .post

        case .unscrap:
            return .delete
        }
    }

    var query: Parameters? { nil }
    var body: Encodable? { nil }
}
