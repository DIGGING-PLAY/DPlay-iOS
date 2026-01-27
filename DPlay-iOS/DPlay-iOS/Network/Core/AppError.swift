//
//  AppError.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 12/3/25.
//

import Foundation

enum AppError: LocalizedError, Equatable{
    
    // 네트워크 관련
    case unauthorized
    case notFound
    case badRequest
    case conflict
    case methodNotAllowed
    case serverError
    case decodeError
    case networkFail
    case emptyData

    // 도메인(비즈니스) 관련
    case invalidParameter
    case operationFailed
    case unknown
    case invalidCoverURL(String)

    var errorDescription: String? {
        switch self {

        // MARK: - Network 기반 에러 메시지
            
        case .unauthorized:
            return "세션이 만료되었습니다. 다시 로그인해주세요."
        case .notFound:
            return "요청한 데이터를 찾을 수 없습니다."
        case .badRequest:
            return "잘못된 요청입니다."
        case .conflict:
            return "이미 처리된 요청입니다."
        case .methodNotAllowed:
            return "허용되지 않은 요청입니다."
        case .serverError:
            return "서버 오류가 발생했습니다."
        case .decodeError:
            return "데이터 처리 중 오류가 발생했습니다."
        case .networkFail:
            return "네트워크 연결을 확인해주세요."
        case .emptyData:
            return "데이터가 존재하지 않습니다."

        // MARK: - Domain 기반 에러 메시지
            
        case .invalidParameter:
            return "올바르지 않은 값입니다."
        case .operationFailed:
            return "요청을 처리하는 데 실패했습니다."
        case .unknown:
            return "알 수 없는 오류가 발생했습니다."
        case .invalidCoverURL(_):
            return "앨범 커버 URL이 유효하지 않습니다."
        }
    }
}
