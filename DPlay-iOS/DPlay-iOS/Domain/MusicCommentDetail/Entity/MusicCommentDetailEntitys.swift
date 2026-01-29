//
//  MusicDetail.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 11/18/25.
//

import Foundation

struct MusicCommentDetail {
    let id: Int
    let isHost: Bool
    let isScrapped: Bool
    let content: String
    let displayDate: String
    let track: MusicTrack
    let user: User
    let like: Like
}
