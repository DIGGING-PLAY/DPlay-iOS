//
//  MyPageTracksDTO.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 12/1/25.
//

import Foundation

struct MyPageTracksResponseDTO: Decodable {
    let status: Bool
    let code: Int
    let message: String
    let data: MyPageTracksDataDTO
}

struct MyPageTracksDataDTO: Decodable {
    let visibleLimit: Int
    let totalCount: Int
    let nextCursor: String?
    let isHost: Bool
    let items: [MyPageTrackItemDTO]
}

struct MyPageTrackItemDTO: Decodable {
    let postId: Int
    let track: MyPageTrackDTO
    let content: String?
}

struct MyPageTrackDTO: Decodable {
    let trackId: String
    let songTitle: String
    let coverImg: String
    let artistName: String
}

// MARK: - DTO to Entity

extension MyPageTracksDataDTO {
    func toEntity() -> MyPageMusics {
        MyPageMusics(
            visibleLimit: visibleLimit,
            totalCount: totalCount,
            nextCursor: nextCursor,
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

extension MyPageTrackDTO {
    func toEntity() -> Track {
        Track(
            id: trackId,
            title: songTitle,
            coverImage: coverImg,
            artist: artistName
        )
    }
}
