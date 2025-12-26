//
//  NetworkLogger.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 12/1/25.
//

import Foundation

import Alamofire

final class NetworkLogger: EventMonitor {
    
    let queue = DispatchQueue(label: "NetworkLogger")

    private let line = "------------------------------------------------------"

    // MARK: - Request Start
    
    func requestDidResume(_ request: Request) {
        print("\n📡📡📡 [REQUEST STARTED] 📡📡📡")
        print(line)
        print("➡️ URL: \(request.request?.url?.absoluteString ?? "nil")")
        print("➡️ METHOD: \(request.request?.httpMethod ?? "nil")")
        
        if let headers = request.request?.allHTTPHeaderFields {
            print("➡️ HEADERS: \(headers)")
        }

        if let body = request.request?.httpBody,
           let bodyString = String(data: body, encoding: .utf8) {
            print("➡️ BODY: \(bodyString)")
        } else {
            print("➡️ BODY: nil")
        }
        
        print(line + "\n")
    }

    // MARK: - Response
    
    func request<Value>(_ request: DataRequest,
                        didParseResponse response: DataResponse<Value, AFError>) {

        print("\n📨📨📨 [RESPONSE RECEIVED] 📨📨📨")
        print(line)
        print("⬅️ URL: \(request.request?.url?.absoluteString ?? "nil")")
        print("⬅️ STATUS CODE: \(response.response?.statusCode ?? 0)")
        
        if let data = response.data,
           let jsonString = prettyPrintedJSON(data) {
            print("⬅️ RESPONSE JSON:\n\(jsonString)")
        } else {
            print("⬅️ RESPONSE DATA: nil")
        }

        if let error = response.error {
            print("\n❗️ ERROR: \(error.localizedDescription)")
        }

        print(line + "\n")
    }

    // MARK: - Pretty Print JSON
    
    private func prettyPrintedJSON(_ data: Data) -> String? {
        do {
            let jsonObj = try JSONSerialization.jsonObject(with: data, options: [])
            let prettyData = try JSONSerialization.data(withJSONObject: jsonObj, options: [.prettyPrinted])
            return String(decoding: prettyData, as: UTF8.self)
        } catch {
            return String(data: data, encoding: .utf8)
        }
    }
}
