//
//  NetworkResult.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 12/1/25.
//

import Foundation

enum NetworkResult<T> {
    case success(T?)
    case badRequest
    case unauthorized
    case notFound
    case conflict
    case methodNotAllowed
    case serverError
    case decodeError
    case networkFail
}
