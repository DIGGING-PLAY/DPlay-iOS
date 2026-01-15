//
//  HomeViewModel.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 11/7/25.
//

import SwiftUI
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    
    @Published var question: Question?
    @Published var posts: [Post] = []
    @Published var isLoading = false
    @Published var isLocked: Bool = false
    @Published var shouldShowPopup: Bool = false
     
    private let homeViewUseCase: HomeViewUseCase
    private let previewMusicUseCase: PreviewMusicUseCase
    weak var coordinator: HomeCoordinator?
    
    init(
        homeViewUseCase: HomeViewUseCase,
        previewMusicUseCase: PreviewMusicUseCase,
        coordinator: HomeCoordinator?
    ) {
        self.homeViewUseCase = homeViewUseCase
        self.previewMusicUseCase = previewMusicUseCase
        self.coordinator = coordinator
    }
}

// MARK: - Home Data Loading

extension HomeViewModel {

    func loadHome() async {
        isLoading = true
        defer { isLoading = false }

        do {
            let homeFeed = try await homeViewUseCase.getHomeData()

            question = homeFeed.question
            isLocked = homeFeed.locked
            posts = homeFeed.locked
                ? Array(homeFeed.posts.prefix(3))
                : homeFeed.posts

        } catch {
            print("❌ Home load failed:", error)
        }
    }
}

// MARK: - Post Actions (Like / Scrap)

extension HomeViewModel {

    func toggleScrap(postId: Int) async {
        guard let index = posts.firstIndex(where: { $0.id == postId }) else { return }

        let original = posts[index]
        let newValue = !original.isScrapped

        posts[index] = original.updated(isScrapped: newValue)

        do {
            try await homeViewUseCase.toggleScrap(
                postId: postId,
                isScrapped: original.isScrapped
            )
        } catch {
            // 실패 시 롤백
            posts[index] = original
            print("스크랩 실패:", error)
        }
    }
}

extension HomeViewModel {

    func toggleLike(postId: Int) async {
        guard let index = posts.firstIndex(where: { $0.id == postId }) else { return }

        let original = posts[index]
        let wasLiked = original.like.isLiked

        let updatedCount = wasLiked
            ? max(original.like.count - 1, 0)
            : original.like.count + 1

        posts[index] = original.updated(
            isLiked: !wasLiked,
            likeCount: updatedCount
        )

        do {
            try await homeViewUseCase.toggleLike(
                postId: postId,
                isLiked: wasLiked
            )
        } catch {
            // 실패 시 롤백
            posts[index] = original
            print("좋아요 실패:", error)
        }
    }
}

// MARK: - Coordinator

extension HomeViewModel {
    func didSelectPost(_ post: Post) {
        coordinator?.goToMusicDetail(trackId: String(post.id))
    }
    
    func goToMonthlyQuestion() {
        coordinator?.goToMonthlyQuestion()
    }
    
    func goToScrapTab() {
        coordinator?.goToScrapTab()
    }
    
    func didTapUserProfile(userId: Int) {
        coordinator?.goToUserProfile()
    }
}

// MARK: - 음악 재생
extension HomeViewModel {

    func didTapPreview(post: Post, playCellId: UUID) {
        Task {
            do {
                let session = try await previewMusicUseCase.execute(
                    trackId: post.track.id,
                    storefront: "kr"
                )

                AudioPlayerManager.shared.playPreview(
                    sessionId: session.sessionId,
                    trackId: session.trackId,
                    streamURL: session.streamURL, playId: playCellId
                )

            } catch {
                print("미리듣기 실패:", error)
            }
        }
    }
}
