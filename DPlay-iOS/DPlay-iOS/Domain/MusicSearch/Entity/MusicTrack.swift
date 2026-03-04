//
//  MusicTrack.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 1/11/26.
//

import Foundation

typealias MusicTrack = Track

struct MusicSearchResult {
    let tracks: [Track]
    let nextCursor: String?
}
