//
//  BaseAPI.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 12/1/25.
//

import Foundation

import Alamofire

/// BaseAPI는 “모든 API 요청의 설계도”
protocol BaseAPI: URLRequestConvertible {

    var method: HTTPMethod { get }  // HTTP Method
    var path: String { get }        // API Path ("/auth/login")
    var query: Parameters? { get }  // Query Parameters (GET)
    var body: Encodable? { get }    // Body Parameters (POST/PUT Body)
    var additionalHeaders: HTTPHeaders { get } // Custom Headers (Optional)
}

extension BaseAPI {
    
    /// 모든 API 공통 baseURL
    var baseURL: String { Config.baseURL + "/api/v1" }

    /// 모든 API 공통 헤더
    var headers: HTTPHeaders {
        var header: HTTPHeaders = ["Content-Type": "application/json"]
        
        // API가 추가로 요구하는 헤더
        additionalHeaders.forEach { header[$0.name] = $0.value }
        return header
    }

    var additionalHeaders: HTTPHeaders { [:] }

    func asURLRequest() throws -> URLRequest {

        let url = try baseURL.asURL().appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.method = method
        request.headers = headers

        // GET → query
        if let query { return try URLEncoding.default.encode(request, with: query) }

        // POST/PUT → body(JSON)
        if let body {
            let dict = body.toDictionary()
            return try JSONEncoding.default.encode(request, with: dict)
        }

        return request
    }
}
