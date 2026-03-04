//
//  MusicComment.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 1/16/26.
//

import Foundation

struct MusicComment {
    let track: Track
    let content: String
}

extension MusicComment {
    func toDTO() -> PostMusicCommentRequestDTO {
        PostMusicCommentRequestDTO(
            trackId: track.id,
            songTitle: track.title,
            artistName: track.artist,
            coverImg: track.coverImageURL,
            isrc: track.isrc ?? "",
            content: content
        )
    }
}
