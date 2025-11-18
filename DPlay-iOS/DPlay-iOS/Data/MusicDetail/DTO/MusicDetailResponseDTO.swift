//
//  MusicDetailResponseDTO.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 11/18/25.
//

import Foundation

// MARK: - MusicDetailResponseDTO

struct MusicDetailResponseDTO: Decodable {
    let status: Bool
    let code: Int
    let message: String
    let data: MusicDetailDataDTO
}

// MARK: - MusicDetailDataDTO

struct MusicDetailDataDTO: Decodable {
    let trackId: String
    let songTitle: String
    let artistName: String
    let coverImg: String
    let isrc: String
}

// MARK: - DTO to Entity

extension MusicDetailDataDTO {
    func toEntity() -> MusicDetail {
        return MusicDetail(
            id: trackId,
            title: songTitle,
            artist: artistName,
            coverImage: coverImg,
            isrc: isrc
        )
    }
}
