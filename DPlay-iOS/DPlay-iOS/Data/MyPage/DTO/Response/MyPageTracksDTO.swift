//
//  MyPageTracksDTO.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 12/1/25.
//

import Foundation

typealias MyPageTracksResponseDTO = BaseResponseDTO<MyPageTracksDataDTO>

struct MyPageTracksDataDTO: Decodable {
    let visibleLimit: Int
    let totalCount: Int
    let nextCursor: String?
    let isHost: Bool?
    let items: [MyPageTrackItemDTO]
}

struct MyPageTrackItemDTO: Decodable {
    let postId: Int
    let track: TrackDTO
    let content: String?
}

// MARK: - DTO to Entity

extension MyPageTracksDataDTO {
    func toEntity() -> MyPageMusics {
        MyPageMusics(
            totalCount: totalCount,
            items: items.map { $0.toEntity() }
        )
    }
}

extension MyPageTrackItemDTO {
    func toEntity() -> MyPageTrackPost {
        MyPageTrackPost(
            id: postId,
            track: track.toEntity(),
            content: content
        )
    }
}
