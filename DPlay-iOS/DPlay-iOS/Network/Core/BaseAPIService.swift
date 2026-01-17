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
            
            //multipart면 upload
            if let multipartAPI = api as? MultipartAPI {
                
                NetworkSession.shared.session
                    .upload(
                        multipartFormData: { form in
                            multipartAPI.buildMultipartFormData(form)
                        },
                        with: multipartAPI
                    )
                    .validate(statusCode: 200..<300)
                    .responseData { response in
                        guard let status = response.response?.statusCode else {
                            continuation.resume(returning: .networkFail)
                            return
                        }

                        switch response.result {

                        case .success(let data):
                            do {
                                let decoded = try JSONDecoder().decode(T.self, from: data)
                                continuation.resume(returning: .success(decoded))
                            } catch {
                                print("❌ Decoding Error:", error)
                                continuation.resume(returning: .decodeError)
                            }

                        case .failure:
                            continuation.resume(returning: self.mapStatusCode(status))
                        }
                    }
                
                return
            }
            
            //일반 JSON이면 request
            NetworkSession.shared.session
                .request(api)
                .validate(statusCode: 200..<300)
                .responseData { response in
                    guard let status = response.response?.statusCode else {
                        continuation.resume(returning: .networkFail)
                        return
                    }

                    switch response.result {

                    case .success(let data):
                        do {
                            let decoded = try JSONDecoder().decode(T.self, from: data)
                            continuation.resume(returning: .success(decoded))
                        } catch {
                            print("❌ Decoding Error:", error)
                            continuation.resume(returning: .decodeError)
                        }

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
