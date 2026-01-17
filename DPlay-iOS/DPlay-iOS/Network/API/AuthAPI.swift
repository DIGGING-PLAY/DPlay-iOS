//
//  AuthAPI.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 1/7/26.
//

import Alamofire

enum AuthAPI {
    case login(appleIdentityToken: String)
    case refreshToken
}

extension AuthAPI: BaseAPI {
    
    var path: String {
        switch self {
        case .login: return "/auth/login"
        case .refreshToken: return "/auth/token/reissue"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .login: return .post
        case .refreshToken: return .patch
        }
    }
    
    var query: Parameters? { nil }
    
    var body: Encodable? {
        switch self {
        case .login:
            return LoginRequestDTO(platform: "APPLE")
        default: return nil
        }
    }
    
    var additionalHeaders: HTTPHeaders {
        switch self {
        case .login(let token):
            return ["Authorization": token]
        case .refreshToken:
            let refreshToken = KeychainManager.shared.refreshToken ?? ""
            return ["Authorization": "Bearer \(refreshToken)"]
        }
    }
}
