//
//  MyPageTrack.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 12/1/25.
//

import Foundation

struct MyPageMusics {
    let visibleLimit: Int
    let nextCursor: String?
    let items: [MyPageTrackPost]
}

struct MyPageTrackPost {
    let id: Int
    let track: Track
    let content: String
}
