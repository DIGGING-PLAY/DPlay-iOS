//
//  MusicSearchMock.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 11/24/25.
//

import Foundation
enum MusicSearchMock {
    static let mockItems: [MusicSearchResponseDTO] = [
        MusicSearchResponseDTO(
            trackId: "apple:1678382",
            songTitle: "Blueming",
            artistName: "IU",
            coverImg: "https://is3-ssl.mzstatic.com/image/thumb/Music114/v4/22/63/4c/22634c94-2049-7805-5a45-44131dfba5c3/19UMGIM72165.rgb.jpg/512x512bb.jpg",
            isrc: "KRA381901710"
        ),
        MusicSearchResponseDTO(
            trackId: "apple:1444980708",
            songTitle: "BBIBBI",
            artistName: "IU",
            coverImg: "https://is2-ssl.mzstatic.com/image/thumb/Music118/v4/b2/df/87/b2df8778-3d74-b028-4397-84701f9193c2/cover.jpg/512x512bb.jpg",
            isrc: "KRB471800263"
        ),
        MusicSearchResponseDTO(
            trackId: "apple:1445046310",
            songTitle: "Palette (feat. G-DRAGON)",
            artistName: "IU",
            coverImg: "https://is1-ssl.mzstatic.com/image/thumb/Music118/v4/19/03/9f/19039ff4-78f8-cc49-fa7a-6538aacb438e/cover.jpg/512x512bb.jpg",
            isrc: "KRA471700143"
        ),
        MusicSearchResponseDTO(
            trackId: "apple:1444980712",
            songTitle: "Through the Night (밤편지)",
            artistName: "IU",
            coverImg: "https://is3-ssl.mzstatic.com/image/thumb/Music118/v4/73/3c/c1/733cc1c9-93a9-dcfa-38ea-fe863deec95b/cover.jpg/512x512bb.jpg",
            isrc: "KRA381700272"
        ),
        MusicSearchResponseDTO(
            trackId: "apple:1533294541",
            songTitle: "eight (feat. SUGA of BTS)",
            artistName: "IU",
            coverImg: "https://is4-ssl.mzstatic.com/image/thumb/Music124/v4/cf/6e/27/cf6e27cd-fc5b-21de-a359-d2795c6b67f6/194491963396.jpg/512x512bb.jpg",
            isrc: "KRA402000284"
        ),
        MusicSearchResponseDTO(
            trackId: "apple:899070042",
            songTitle: "Good Day",
            artistName: "IU",
            coverImg: "https://is4-ssl.mzstatic.com/image/thumb/Music3/v4/29/d9/0e/29d90ea8-b214-074f-b2d4-30c75c12118e/cover.jpg/512x512bb.jpg",
            isrc: "KRB391002600"
        )
    ]
}
