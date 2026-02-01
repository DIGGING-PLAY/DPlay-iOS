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
    let badge: BadgeDTO?
    let track: HomeFeedTrackDTO
    let user: UserDTO
    let like: LikeDTO
}

// MARK: - HomeFeedBadgesDTO

enum BadgeDTO: String, Decodable {
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

struct UserDTO: Decodable {
    let userId: Int
    let nickname: String
    let profileImg: String?
    let isAdmin: Bool
}

// MARK: - HomeFeedLikeDTO

struct LikeDTO: Decodable {
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

extension BadgeDTO {
    func toEntity() -> Badge {
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

extension UserDTO {
    func toEntity() -> User {
        User(id: userId, nickname: nickname, profileImage: profileImg, isAdmin: isAdmin)
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

extension LikeDTO {
    func toEntity() -> Like {
        Like(isLiked: isLiked, count: count)
    }
}
