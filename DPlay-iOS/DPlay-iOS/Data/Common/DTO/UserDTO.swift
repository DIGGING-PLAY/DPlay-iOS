//
//  UserDTO.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 11/16/25.
//

import Foundation

struct UserDTO: Decodable {
    let userId: Int
    let nickname: String
    let profileImg: String?
    let isAdmin: Bool
}

// MARK: - DTO to Entity

extension UserDTO {
    func toEntity() -> User {
        User(id: userId, nickname: nickname, profileImage: profileImg, isAdmin: isAdmin)
    }
}
