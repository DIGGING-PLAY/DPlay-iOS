//
//  MusicTrack.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 1/11/26.
//

import Foundation

struct MusicSearchResult {
    let tracks: [MusicTrack]
    let nextCursor: String?
}

struct MusicTrack {
    let trackId: String
    let title: String
    let artist: String
    let coverURL: URL
    let isrc: String
}
