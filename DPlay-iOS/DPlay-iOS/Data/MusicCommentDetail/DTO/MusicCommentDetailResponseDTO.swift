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

extension MusicCommentDetailResponseDTO {
    func toEntity() throws -> MusicCommentDetail {

        guard let data else {
            throw AppError.emptyData
        }

        return MusicCommentDetail(
            id: data.postId,
            isHost: data.isHost,
            isScrapped: data.isScrapped,
            content: data.content,
            displayDate: data.displayDate,
            track: try data.track.toEntity(),
            user: data.user.toEntity(),
            like: data.like.toEntity()
        )
    }
}
