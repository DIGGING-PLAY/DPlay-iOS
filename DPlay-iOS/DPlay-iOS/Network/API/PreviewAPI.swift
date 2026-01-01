//
//  PreviewAPI.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 1/1/26.
//

import Foundation

import Alamofire

enum PreviewAPI {
    case previewTrack(trackId: String, storefront: String?)
}

extension PreviewAPI: BaseAPI {

    var path: String {
        switch self {
        case .previewTrack(let trackId, _):
            return "/api/v1/tracks/preview/\(trackId)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .previewTrack:
            return .post
        }
    }

    var query: Parameters? {
        switch self {
        case .previewTrack(_, let storefront):
            guard let storefront else { return nil }
            return ["storefront": storefront]
        }
    }

    var body: Encodable? {
        return nil
    }
}
