//
//  RecommendedSongsEntity.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 11/7/25.
//

import Foundation

struct HomeFeed {
    let question: Question
    let totalCount: Int
    let locked: Bool
    let posts: [Post]
}

struct Question {
    let id: Int
    let title: String
    let date: String
    let hasPosted: Bool
}

struct Post {
    let id: Int
    let content: String
    let user: User
    let track: Track
    let like: Like
    let badges: Badge
    let isScrapped: Bool
}

extension Post {

    func updated(
        isScrapped: Bool? = nil,
        isLiked: Bool? = nil,
        likeCount: Int? = nil
    ) -> Post {
        let updatedLike = Like(
            isLiked: isLiked ?? like.isLiked,
            count: likeCount ?? like.count
        )

        return Post(
            id: id,
            content: content,
            user: user,
            track: track,
            like: updatedLike,
            badges: badges,
            isScrapped: isScrapped ?? self.isScrapped
        )
    }
}
