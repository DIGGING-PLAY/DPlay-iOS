//
//  CreatePostRequestDTO.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 1/11/26.
//

import Foundation

struct PostMusicCommentRequestDTO: Encodable {
    let trackId: String
    let songTitle: String
    let artistName: String
    let coverImg: String
    let isrc: String
    let content: String
}
