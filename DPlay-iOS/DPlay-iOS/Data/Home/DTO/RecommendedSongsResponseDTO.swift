//
//  RecommendedSongsDTO.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 11/16/25.
//

import Foundation

// MARK: - HomeFeedResponseDTO

typealias HomeFeedResponseDTO = BaseResponseDTO<HomeFeedDataDTO>

// MARK: - HomeFeedDataDTO

struct HomeFeedDataDTO: Decodable {
    let questionId: Int
    let title: String
    let date: String
    let hasPosted: Bool
    let locked: Bool
    let totalCount: Int
    let items: [HomeFeedPostDTO]
}

// MARK: - HomeFeedPostDTO

struct HomeFeedPostDTO: Decodable {
    let postId: Int
    let isScrapped: Bool
    let content: String
    let badge: HomeFeedBadgeDTO?
    let track: HomeFeedTrackDTO
    let user: HomeFeedUserDTO
    let like: HomeFeedLikeDTO
}

// MARK: - HomeFeedBadgesDTO

enum HomeFeedBadgeDTO: String, Decodable {
    case editor = "EDITOR"
    case best   = "BEST"
    case new    = "NEW"
}

// MARK: - HomeFeedTrackDTO

struct HomeFeedTrackDTO: Decodable {
    let trackId: String
    let songTitle: String
    let coverImg: String
    let artistName: String
}

// MARK: - HomeFeedUserDTO

struct HomeFeedUserDTO: Decodable {
    let userId: Int
    let nickname: String
    let profileImg: String?
}

// MARK: - HomeFeedLikeDTO

struct HomeFeedLikeDTO: Decodable {
    let isLiked: Bool
    let count: Int
}

// MARK: - DTO to Entity

extension HomeFeedDataDTO {
    func toEntity() -> HomeFeed {
        HomeFeed(
            question: Question(
                id: questionId,
                title: title,
                date: date,
                hasPosted: hasPosted
            ),
            totalCount: totalCount,
            locked: locked,
            posts: items.map { $0.toEntity() }
        )
    }
}

extension HomeFeedBadgeDTO {
    func toEntity() -> HomeFeedBadge {
        switch self {
        case .editor: return .editor
        case .best:   return .best
        case .new:    return .new
        }
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
            badges: badge?.toEntity() ?? .nomal,
            isScrapped: isScrapped
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
