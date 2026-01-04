//
//  QuestionPostsDTO.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 12/30/25.
//

import Foundation

typealias QuestionPostsResponseDTO = BaseResponseDTO<QuestionPostsDataDTO>

struct QuestionPostsDataDTO: Decodable {
    let questionId: Int
    let date: String
    let title: String
    let hasPosted: Bool
    let locked: Bool
    let visibleLimit: Int
    let totalCount: Int
    let nextCursor: String?
    let items: [QuestionPostsItemDTO]
}

struct QuestionPostsItemDTO: Decodable {
    let postId: Int
    let isEditorPick: Bool
    let isScrapped: Bool
    let content: String
    let track: QuestionPostsTrackDTO
    let user: QuestionPostsUserDTO
    let like: QuestionPostsLikeDTO
}

struct QuestionPostsTrackDTO: Decodable {
    let trackId: String
    let songTitle: String
    let coverImg: String
    let artistName: String
}

struct QuestionPostsUserDTO: Decodable {
    let userId: Int
    let nickname: String
    let profileImg: String
}

struct QuestionPostsLikeDTO: Decodable {
    let isLiked: Bool
    let count: Int
}
