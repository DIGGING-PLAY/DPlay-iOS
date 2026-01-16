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
}

extension MusicSearchAPI: BaseAPI {
    
    var path: String {
        switch self {
        case .searchTracks:
            return "/tracks"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .searchTracks:
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
        }
    }
    
    var body: Encodable? {
        return nil
    }
}
