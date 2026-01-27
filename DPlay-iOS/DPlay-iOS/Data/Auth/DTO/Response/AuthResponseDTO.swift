//
//  AuthResponseDTO.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 11/22/25.
//

typealias AuthResponseDTO = BaseResponseDTO<AuthDataDTO>

struct AuthDataDTO: Decodable {
    let userId: Int
    let accessToken: String
    let refreshToken: String
}

extension AuthDataDTO {
    func toEntity() -> UserSession {
        return UserSession(
            userId: userId,
            accessToken: accessToken,
            refreshToken: refreshToken
        )
    }
}
