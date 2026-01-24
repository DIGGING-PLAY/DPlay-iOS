//
//  PostActionAPI.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 1/24/26.
//

import Foundation

import Alamofire

enum PostActionAPI {
    case likePost(postId: Int)
    case unlikePost(postId: Int)
    case scrap(postId: Int)
    case unscrap(postId: Int)
}

extension PostActionAPI: BaseAPI {

    var path: String {
        switch self {
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
        case .likePost, .scrap:
            return .post
        case .unlikePost, .unscrap:
            return .delete
        }
    }

    var query: Parameters? { nil }
    var body: Encodable? { nil }
}
