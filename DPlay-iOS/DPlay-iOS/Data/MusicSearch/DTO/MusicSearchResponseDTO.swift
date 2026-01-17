//
//  MusicSearchResponseDTO.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 11/24/25.
//
import Foundation

typealias MusicSearchResponseDTO = BaseResponseDTO<MusicSearchDataDTO>

struct MusicSearchDataDTO: Decodable {
    let query: String
    let storefront: String
    let limit: Int
    let nextCursor: String?
    let items: [MusicTrackItemDTO]
}

typealias TrackDetailResponseDTO = BaseResponseDTO<MusicTrackItemDTO>

struct MusicTrackItemDTO: Decodable {
    let trackId: String
    let songTitle: String
    let artistName: String
    let coverImg: String
    let isrc: String
}

extension MusicTrackItemDTO {
    func toEntity() throws -> MusicTrack {
       
        guard let url = URL(string: coverImg) else {
                throw AppError.invalidCoverURL(coverImg)
        }
        
        return MusicTrack(
            trackId: trackId,
            title: songTitle,
            artist: artistName,
            coverURL: url,
            isrc: isrc
        )
    }
}
