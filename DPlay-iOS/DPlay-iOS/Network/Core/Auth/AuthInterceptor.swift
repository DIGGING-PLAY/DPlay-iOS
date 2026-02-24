//
//  AuthInterceptor.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 12/1/25.
//

import Foundation

import Alamofire

final class AuthInterceptor: RequestInterceptor {
    
    // MARK: - 1) Access Token 자동 주입
    
    func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Result<URLRequest, Error>) -> Void
    ) {
        
        var request = urlRequest
        
        if let url = request.url, url.path.contains("/auth/token/reissue"), url.path.contains("/auth/login") {
            completion(.success(request))
            return
        }
        
        if let token = KeychainManager.shared.accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        completion(.success(request))
    }
    
    // MARK: - 2) 401 발생 시 Refresh 후 재시도
    
    func retry(
        _ request: Request,
        for session: Session,
        dueTo error: Error,
        completion: @escaping (RetryResult) -> Void
    ) {
        
        guard request.response?.statusCode == 401 && !isRefreshRequest(request) else {
            completion(.doNotRetry)
            return
        }
        
        Task {
            let success = await TokenRefreshManager.shared.refresh()
            completion(success ? .retry : .doNotRetry)
        }
    }
}

private extension AuthInterceptor {
    
    //token refresh 요청인지 확인
    func isRefreshRequest(_ request: Request) -> Bool {
        guard let url = request.request?.url else { return false }
        return url.path.contains("/auth/token/reissue")
    }
}
