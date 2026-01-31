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
    let profileImg: String?
    let isAdmin: Bool
}

struct QuestionPostsLikeDTO: Decodable {
    let isLiked: Bool
    let count: Int
}

extension QuestionPostsDataDTO {
    func toEntity() -> QuestionPosts {
        QuestionPosts(
            id: questionId,
            date: date,
            title: title,
            hasPosted: hasPosted,
            locked: locked,
            visibleLimit: visibleLimit,
            totalCount: totalCount,
            nextCursor: nextCursor,
            items: items.map { $0.toEntity() }
        )
    }
}

extension QuestionPostsItemDTO {
    func toEntity() -> QuestionPost {
        QuestionPost(
            id: postId,
            isEditorPick: isEditorPick,
            isScrapped: isScrapped,
            content: content,
            track: track.toEntity(),
            user: user.toEntity(),
            like: like.toEntity()
        )
    }
}

extension QuestionPostsTrackDTO {
    func toEntity() -> Track {
        Track(
            id: trackId,
            title: songTitle,
            coverImage: coverImg,
            artist: artistName
        )
    }
}

extension QuestionPostsUserDTO {
    func toEntity() -> User {
        User(
            id: userId,
            nickname: nickname,
            profileImage: profileImg,
            isAdmin: isAdmin
        )
    }
}

extension QuestionPostsLikeDTO {
    func toEntity() -> Like {
        Like(isLiked: isLiked, count: count)
    }
}
