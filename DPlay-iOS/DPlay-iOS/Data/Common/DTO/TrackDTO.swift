//
//  TrackDTO.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 11/16/25.
//

import Foundation

struct TrackDTO: Decodable {
    let trackId: String
    let songTitle: String
    let coverImg: String
    let artistName: String
}

// MARK: - DTO to Entity

extension TrackDTO {
    func toEntity() -> Track {
        Track(
            id: trackId,
            title: songTitle,
            artist: artistName,
            coverImageURL: coverImg,
            isrc: nil
        )
    }
}
