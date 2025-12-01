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
        
        if let token = KeychainManager.shared.accessToken {
            // 대부분 서버는 Bearer prefix 요구
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
        
        guard request.response?.statusCode == 401 else {
            completion(.doNotRetry)
            return
        }
        
        Task {
            let success = await TokenRefreshManager.shared.refresh()
            completion(success ? .retry : .doNotRetry)
        }
    }
}
