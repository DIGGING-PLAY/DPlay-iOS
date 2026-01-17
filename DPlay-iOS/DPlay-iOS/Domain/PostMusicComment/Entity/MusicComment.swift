//
//  MusicComment.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 1/16/26.
//

import Foundation

struct MusicComment {
    let trackId: String
    let songTitle: String
    let artistName: String
    let coverImg: URL
    let isrc: String
    let content: String
}

extension MusicComment {
    func toDTO() -> PostMusicCommentRequestDTO {
        PostMusicCommentRequestDTO(
            trackId: trackId,
            songTitle: songTitle,
            artistName: artistName,
            coverImg: coverImg.absoluteString,
            isrc: isrc,
            content: content
        )
    }
}
