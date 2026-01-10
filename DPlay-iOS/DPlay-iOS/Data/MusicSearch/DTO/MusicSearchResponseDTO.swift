//
//  MusicSearchResponseDTO.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 11/24/25.
//
import Foundation

struct MusicSearchResponseDTO: Codable, Hashable {
    let trackId: String
    let songTitle: String
    let artistName: String
    let coverImg: String
    let isrc: String
}
