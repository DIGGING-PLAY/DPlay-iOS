//
//  MyPageProfileDTO.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 12/1/25.
//

import Foundation

struct MyPageProfileResponseDTO: Decodable {
    let status: Bool
    let code: Int
    let message: String
    let data: MyPageProfileDataDTO
}

struct MyPageProfileDataDTO: Decodable {
    let user: MyPageUserDTO
    let isHost: Bool
    let pushOn: Bool
    let postTotalCount: Int
}

struct MyPageUserDTO: Decodable {
    let userId: Int
    let nickname: String
    var image: String?
}

// MARK: - DTO to Entity

extension MyPageProfileDataDTO {
    func toEntity() -> UserProfile {
        UserProfile(
            user: user.toEntity(),
            postTotalCount: postTotalCount
        )
    }
}

extension MyPageUserDTO {
    func toEntity() -> User {
        User(
            id: userId,
            nickname: nickname,
            profileImage: image
        )
    }
}
