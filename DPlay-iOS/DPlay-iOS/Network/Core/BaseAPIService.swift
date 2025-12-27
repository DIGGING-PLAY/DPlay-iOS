//
//  BaseAPIService.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 12/1/25.
//

import Foundation
import Alamofire

// MARK: - BaseAPIService — 네트워크의 “중앙 관제실”

final class BaseAPIService {

    /// “네트워크 요청을 실행하는 단 하나의 진입점”
    func request<T: Decodable>(
        _ api: BaseAPI,
        _ type: T.Type
    ) async -> NetworkResult<T> {

        return await withCheckedContinuation { continuation in

            NetworkSession.shared.session
                .request(api)
                .validate(statusCode: 200..<600)
                .responseData { response in

                    guard let status = response.response?.statusCode else {
                        continuation.resume(returning: .networkFail)
                        return
                    }

                    switch response.result {

                    case .success(let data):
                        
                        // BaseResponseDTO<T> 로 감싸기
                        if let decoded = try? JSONDecoder().decode(BaseResponseDTO<T>.self, from: data) {

                            if decoded.success {
                                continuation.resume(returning: .success(decoded.data))
                                return
                            } else {
                                // 단순히 서버에서 success: false 내려주는 경우
                                continuation.resume(returning: .serverError)
                                return
                            }
                        }
                        continuation.resume(returning: .decodeError)

                    case .failure:
                        continuation.resume(returning: self.mapStatusCode(status))
                    }
                }
        }
    }

    private func mapStatusCode<T>(_ status: Int) -> NetworkResult<T> {
        switch status {
        case 400: return .badRequest
        case 401: return .unauthorized
        case 404: return .notFound
        case 405: return .methodNotAllowed
        case 409: return .conflict
        case 500: return .serverError
        default: return .networkFail
        }
    }
}
