//
//  AuthAPI.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 1/7/26.
//

import Alamofire

enum AuthAPI {
    case login(appleIdentityToken: String)
}

extension AuthAPI: BaseAPI {
    
    var path: String {
        switch self {
        case .login: return "/auth/login"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .login: return .post
        }
    }
    
    var query: Parameters? { nil }
    
    var body: Encodable? {
        switch self {
        case .login:
            return LoginRequestDTO(platform: "APPLE")
        }
    }
    
    var additionalHeaders: HTTPHeaders {
        switch self {
        case .login(let token):
            return ["Authorization": token]
        }
    }
}
