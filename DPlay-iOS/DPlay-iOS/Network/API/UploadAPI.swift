//
//  UploadAPI.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 1/11/26.
//

import Alamofire
import Foundation

protocol MultipartAPI: BaseAPI {
    func buildMultipartFormData(_ form: MultipartFormData)
}

enum UploadAPI {
    case signup(appleIdentityToken: String, signupRequestBody: SignupRequestDTO, profileImg: Data?)
}

extension UploadAPI: MultipartAPI {
    
    var path: String {
        switch self {
        case .signup: return "/auth/signup"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .signup: return .post
        }
    }
    
    var query: Parameters? { nil }
    
    var body: Encodable? { nil }
    
    var additionalHeaders: HTTPHeaders {
        switch self {
        case .signup(let token, _, _):
            return ["Authorization": token]
        }
    }
    
    func buildMultipartFormData(_ form: MultipartFormData) {
        switch self {
        case let .signup(_, signupRequest, profileImg):
            
            // 이미지
            if let imageData = profileImg {
                form.append(
                    imageData,
                    withName: "profileImg",
                    fileName: "profileImg.jpeg",
                    mimeType: "image/jpeg"
                )
            }
            
            //signupRequest를 application/json로
            let encoder = JSONEncoder()
            if let jsonData = try? encoder.encode(signupRequest) {
                form.append(
                    jsonData,
                    withName: "signupRequest",
                    fileName: "signupRequest.json",
                    mimeType: "application/json"
                )
            }
        }
    }
}
