//
//  AuthDTO.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 11/22/25.
//

struct AuthResponseDTO: Decodable {
    let success: Bool
    let code: Int
    let message: String
    let data: AuthDataDTO
}

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
