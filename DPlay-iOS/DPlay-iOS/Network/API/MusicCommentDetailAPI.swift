//
//  MusicCommentDetailAPI.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 1/24/26.
//

import Foundation

import Alamofire

enum MusicCommentDetailAPI {
    case fetchMusicCommentDetail(postId: Int)
    case deleteMusicCommentDetail(postId: Int)
}

extension MusicCommentDetailAPI: BaseAPI {
    
    var path: String {
        switch self {
        case .fetchMusicCommentDetail(let postId):
            return "/posts/detail/\(postId)"
            
        case .deleteMusicCommentDetail(let postId):
            return "/posts/\(postId)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .fetchMusicCommentDetail:
            return .get
            
        case .deleteMusicCommentDetail:
            return .delete
        }
    }

    var query: Parameters? { nil }
    var body: Encodable? { nil }
}
