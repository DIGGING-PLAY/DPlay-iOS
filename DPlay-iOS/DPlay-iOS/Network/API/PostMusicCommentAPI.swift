//
//  PostMusicCommentAPI.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 1/11/26.
//

import Foundation

import Alamofire

enum PostMusicCommentAPI {
    
    /// 노래 상세 조회
    case fetchTrackDetail(
        trackId: String,
        storefront: String
    )
    
    // 음악 코맨트 생성
    case createPost(request: PostMusicCommentRequestDTO)
}

extension PostMusicCommentAPI: BaseAPI {
    
    var path: String {
        switch self {
        case .fetchTrackDetail(let trackId, _):
            return "/tracks/\(trackId)"
        case .createPost:
            return "/posts"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchTrackDetail:
            return .get
        case .createPost:
            return .post
        }
    }
    
    var query: Parameters? {
        switch self {
        case .fetchTrackDetail(_, let storefront):
            return [
                "storefront": storefront
            ]
        default:
            return nil
        }
    }
    
    var body: Encodable? {
        switch self {
        case .createPost(let request):
            return request
        default:
            return nil
        }
    }
}
