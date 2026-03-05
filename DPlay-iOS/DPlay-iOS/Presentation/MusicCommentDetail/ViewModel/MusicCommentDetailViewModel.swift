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

    private let commentDetailUseCase: MusicCommentDetailUseCase
    private let previewMusicUseCase: PreviewMusicUseCase
    weak var coordinator: DetailCoordinating?
    private let postId: Int
    private var previewTask: Task<Void, Never>?
    
    init(
        postId: Int,
        initialBadge: Badge,
        commentDetailUseCase: MusicCommentDetailUseCase,
        previewMusicUseCase: PreviewMusicUseCase,
        coordinator: DetailCoordinating?
    ) {
        self.postId = postId
        self.badge = initialBadge
        self.commentDetailUseCase = commentDetailUseCase
        self.previewMusicUseCase = previewMusicUseCase
        self.coordinator = coordinator
    }
}

// MARK: - Data Loading

extension MusicCommentDetailViewModel {

    func loadDetail() async {
        do {
            print("뷰모델 postId \(postId)")
            detail = try await commentDetailUseCase.getMusicDetail(postId: postId)
        } catch {
            print("❌ Detail load failed:", error)
        }
    }
}

// MARK: - Data Delete

extension MusicCommentDetailViewModel {

    func deletePost() async {
        do {
            try await commentDetailUseCase.deletePost(postId: postId)
            coordinator?.pop()
            AppEventBus.shared.event.send(
                .homeShouldRefresh(reason: .commentDeleted)
            )
            AppEventBus.shared.event.send(
                .mypageShouldRefresh(reason: .commentDeleted)
            )
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
            try await commentDetailUseCase.toggleLike(
                postId: original.id,
                isLiked: wasLiked
            )
            
            AppEventBus.shared.event.send(
                .homeShouldRefresh(reason: .likeToggled)
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
            try await commentDetailUseCase.toggleScrap(
                postId: original.id,
                isScrapped: original.isScrapped
            )
            
            AppEventBus.shared.event.send(
                .homeShouldRefresh(reason: .scrapToggled)
            )
            AppEventBus.shared.event.send(
                .mypageShouldRefresh(reason: .scrapToggled)
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
    
    func goToScrapTab() {
        coordinator?.popToRoot()
        coordinator?.goToScrapTab()
    }
    
    func goToUserProfile() {
        let myUserId = UserDefaults.standard.integer(forKey: "userId")
        
        if detail?.user.id ?? 0 == myUserId {
            goToScrapTab()
        } else {
            coordinator?.goToUserProfile(userId: detail?.user.id ?? 0)
        }
    }
}

// MARK: - 음악 재생
extension MusicCommentDetailViewModel {

    func didTapPreview() {
        guard let trackId = detail?.track.id, !trackId.isEmpty else { return }
        previewTask?.cancel()
        previewTask = Task {
            do {
                let session = try await previewMusicUseCase.execute(
                    trackId: trackId,
                    storefront: "kr"
                )

                AudioPlayerManager.shared.playPreview(
                    sessionId: session.sessionId,
                    trackId: session.trackId,
                    streamURL: session.streamURL, playId: nil
                )

            } catch {
                print("미리듣기 실패:", error)
            }
        }
    }
}
