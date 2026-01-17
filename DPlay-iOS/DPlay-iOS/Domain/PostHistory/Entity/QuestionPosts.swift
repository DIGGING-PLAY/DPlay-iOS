//
//  QuestionPosts.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 1/18/26.
//

struct QuestionPosts {
    let id: Int
    let date: String
    let title: String
    let hasPosted: Bool
    let locked: Bool
    let visibleLimit: Int
    let totalCount: Int
    let nextCursor: String?
    let items: [QuestionPost]
}

struct QuestionPost {
    let id: Int
    let isEditorPick: Bool
    let isScrapped: Bool
    let content: String
    let track: Track
    let user: User
    let like: Like
}
