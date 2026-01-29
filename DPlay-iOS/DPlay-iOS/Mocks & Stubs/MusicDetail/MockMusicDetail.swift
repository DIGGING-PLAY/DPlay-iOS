//
//  MockMusicDetail.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 11/18/25.
//

import Foundation

enum MockMusicDetail {
    static let sample = MusicTrack(
        trackId: "apple:1678382",
        title: "Blueming",
        artist: "IU",
        coverURL: URL(string: "https://example.com/cover.jpg")!,
        isrc: "KRA381901710"
    )
}
