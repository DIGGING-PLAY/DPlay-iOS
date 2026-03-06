//
//  LikeDTO.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 11/16/25.
//

import Foundation

struct LikeDTO: Decodable {
    let isLiked: Bool
    let count: Int
}

// MARK: - DTO to Entity

extension LikeDTO {
    func toEntity() -> Like {
        Like(isLiked: isLiked, count: count)
    }
}
