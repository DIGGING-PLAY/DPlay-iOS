//
//  MusicCommentDetailViewModel.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 11/18/25.
//

import SwiftUI
import Combine

@MainActor
final class MusicCommentDetailViewModel: ObservableObject {
    
    @Published var detail: MusicCommentDetail?
    @Published var badge: Badge
    
    private let useCase: MusicCommentDetailUseCase
    weak var coordinator: HomeCoordinator?
    private let postId: Int
    
    init(
        postId: Int,
        initialBadge: Badge,
        useCase: MusicCommentDetailUseCase,
        coordinator: HomeCoordinator?
    ) {
        self.postId = postId
        self.badge = initialBadge
        self.useCase = useCase
        self.coordinator = coordinator
    }
}

// MARK: - Data Loading

extension MusicCommentDetailViewModel {

    func loadDetail() async {
        do {
            print("뷰모델 postId \(postId)")
            detail = try await useCase.getMusicDetail(postId: postId)
        } catch {
            print("❌ Detail load failed:", error)
        }
    }
}

// MARK: - Data Delete

extension MusicCommentDetailViewModel {

    func deletePost() async {
        do {
            try await useCase.deletePost(postId: postId)
            coordinator?.pop()
        } catch {
            print("❌ 삭제 실패:", error)
        }
    }
}

// MARK: - Post Actions (Like / Scrap)

extension MusicCommentDetailViewModel {

    func toggleLike() async {
        guard let original = detail else { return }

        let wasLiked = original.like.isLiked
        let updatedCount = wasLiked
            ? max(original.like.count - 1, 0)
            : original.like.count + 1

        // optimistic update
        detail = MusicCommentDetail(
            id: original.id,
            isHost: original.isHost,
            isScrapped: original.isScrapped,
            content: original.content,
            displayDate: original.displayDate,
            track: original.track,
            user: original.user,
            like: Like(
                isLiked: !wasLiked,
                count: updatedCount
            )
        )

        do {
            try await useCase.toggleLike(
                postId: original.id,
                isLiked: wasLiked
            )
        } catch {
            // rollback
            detail = original
            print("❌ 좋아요 실패:", error)
        }
    }
}

extension MusicCommentDetailViewModel {

    func toggleScrap() async {
        guard let original = detail else { return }

        let newValue = !original.isScrapped

        // optimistic update
        detail = MusicCommentDetail(
            id: original.id,
            isHost: original.isHost,
            isScrapped: newValue,
            content: original.content,
            displayDate: original.displayDate,
            track: original.track,
            user: original.user,
            like: original.like
        )

        do {
            try await useCase.toggleScrap(
                postId: original.id,
                isScrapped: original.isScrapped
            )
        } catch {
            // rollback
            detail = original
            print("❌ 스크랩 실패:", error)
        }
    }
}

// MARK: - Coordinator

extension MusicCommentDetailViewModel {
    func didTapBack() {
        coordinator?.pop()
    }
}
