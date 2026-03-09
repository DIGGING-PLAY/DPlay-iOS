//
//  MusicDetailResponseDTO.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 11/18/25.
//

import Foundation

// MARK: - MusicDetailResponseDTO

typealias MusicCommentDetailResponseDTO = BaseResponseDTO<MusicPostDetailDTO>

// MARK: - MusicDetailDataDTO

struct MusicPostDetailDTO: Decodable {
    let postId: Int
    let isHost: Bool
    let isScrapped: Bool
    let content: String
    let displayDate: String
    let track: MusicTrackItemDTO
    let user: UserDTO
    let like: LikeDTO
}

extension MusicPostDetailDTO {
    func toEntity() -> MusicCommentDetail {
        MusicCommentDetail(
            id: postId,
            isHost: isHost,
            isScrapped: isScrapped,
            content: content,
            displayDate: displayDate,
            track: track.toEntity(),
            user: user.toEntity(),
            like: like.toEntity()
        )
    }
}
