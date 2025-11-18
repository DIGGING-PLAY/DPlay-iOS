//
//  RecommendedSongsDTO.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 11/16/25.
//

import Foundation

// MARK: - RecommendedSongsDTO
struct HomeFeedResponseDTO: Decodable {
    let status: Bool
    let code: Int
    let message: String
    let data: HomeFeedDataDTO
}

// MARK: - HomeDataDTO
struct HomeFeedDataDTO: Decodable {
    let questionId: Int
    let date: String
    let hasPosted: Bool
    let locked: Bool
    let totalCount: Int
    let items: [HomeFeedPostDTO]
}

// MARK: - PostDTO
struct HomeFeedPostDTO: Decodable {
    let postId: Int
    let isScrapped: Bool
    let content: String
    let badges: HomeFeedBadgesDTO
    let track: HomeFeedTrackDTO
    let user: HomeFeedUserDTO
    let like: HomeFeedLikeDTO
}

struct HomeFeedBadgesDTO: Decodable {
    let isEditorPick: Bool
    let isPopular: Bool
    let isNew: Bool
}

struct HomeFeedTrackDTO: Decodable {
    let trackId: String
    let songTitle: String
    let coverImg: String
    let artistName: String
}

struct HomeFeedUserDTO: Decodable {
    let userId: Int
    let nickname: String
    let profileImg: String
}

struct HomeFeedLikeDTO: Decodable {
    let isLiked: Bool
    let count: Int
}

extension HomeFeedDataDTO {
    func toEntity() -> (Question, [Post]) {
        let question = Question(
            id: questionId,
            date: date,
            hasPosted: hasPosted
        )

        let posts = items.map { $0.toEntity() }
        return (question, posts)
    }
}

extension HomeFeedPostDTO {
    func toEntity() -> Post {
        Post(
            id: postId,
            content: content,
            user: user.toEntity(),
            track: track.toEntity(),
            like: like.toEntity(),
            badges: badges.toEntity(),
            isScrapped: isScrapped
        )
    }
}

extension HomeFeedBadgesDTO {
    func toEntity() -> Badges {
        Badges(
            isEditorPick: isEditorPick,
            isPopular: isPopular,
            isNew: isNew
        )
    }
}

extension HomeFeedUserDTO {
    func toEntity() -> User {
        User(id: userId, nickname: nickname, profileImage: profileImg)
    }
}

extension HomeFeedTrackDTO {
    func toEntity() -> Track {
        Track(
            id: trackId,
            title: songTitle,
            coverImage: coverImg,
            artist: artistName
        )
    }
}

extension HomeFeedLikeDTO {
    func toEntity() -> Like {
        Like(isLiked: isLiked, count: count)
    }
}
