//
//  MusicSearchAPI.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 1/11/26.
//

import Foundation

import Alamofire

enum MusicSearchAPI {
    
    /// 노래 검색
    case searchTracks(
        query: String,
        limit: Int,
        storefront: String,
        cursor: String?
    )
    
    /// 노래 상세 조회
    case fetchTrackDetail(
        trackId: String,
        storefront: String
    )
}

extension MusicSearchAPI: BaseAPI {

    var path: String {
        switch self {
        case .searchTracks:
            return "/tracks"
            
        case .fetchTrackDetail(let trackId, _):
            return "/tracks/\(trackId)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .searchTracks,
             .fetchTrackDetail:
            return .get
        }
    }

    var query: Parameters? {
        switch self {
        case let .searchTracks(query, limit, storefront, cursor):
            var params: Parameters = [
                "query": query,
                "limit": limit,
                "storefront": storefront
            ]
            if let cursor {
                params["cursor"] = cursor
            }
            return params

        case let .fetchTrackDetail(_, storefront):
            return [
                "storefront": storefront
            ]
        }
    }

    var body: Encodable? {
        return nil
    }
}
