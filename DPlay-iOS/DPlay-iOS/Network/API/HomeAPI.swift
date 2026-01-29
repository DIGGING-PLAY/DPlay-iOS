//
//  HomeAPI.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 12/1/25.
//

import Foundation

import Alamofire

enum HomeAPI {
    case fetchHomeFeed
}

extension HomeAPI: BaseAPI {
    
    var path: String {
        switch self {
        case .fetchHomeFeed:
            return "/posts/today"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchHomeFeed:
            return .get
        }
    }
    
    var query: Parameters? { nil }
    var body: Encodable? { nil }
}
