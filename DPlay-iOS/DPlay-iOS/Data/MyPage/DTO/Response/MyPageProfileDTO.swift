//
//  MyPageProfileDTO.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 12/1/25.
//

import Foundation

typealias MyPageProfileResponseDTO = BaseResponseDTO<MyPageProfileDataDTO>

struct MyPageProfileDataDTO: Decodable {
    let user: UserDTO
    let isHost: Bool
    let pushOn: Bool
    let postTotalCount: Int
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
