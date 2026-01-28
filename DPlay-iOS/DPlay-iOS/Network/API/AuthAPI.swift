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
    case setNotification(pushOn: Bool)
    case logout
    case withdraw(appleAuthorizationCode: String)
}

extension AuthAPI: BaseAPI {
    
    var path: String {
        switch self {
        case .login: return "/auth/login"
        case .refreshToken: return "/auth/token/reissue"
        case .setNotification: return "/users/me/notifications"
        case .logout: return "/auth/logout"
        case .withdraw: return "/auth/withdraw"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .login, .setNotification: return .post
        case .refreshToken: return .patch
        case .logout, .withdraw: return .delete
        }
    }
    
    var query: Parameters? { nil }
    
    var body: Encodable? {
        switch self {
        case .login:
            return LoginRequestDTO(platform: "APPLE")
        case .setNotification(let pushOn):
            return NotificationRequestDTO(pushOn: pushOn)
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
        case .withdraw(let appleAuthorizationCode):
            return ["Apple-Auth-Code": appleAuthorizationCode]
        default: return [:]
        }
    }
}
