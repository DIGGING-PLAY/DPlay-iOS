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
    
    // MARK: - Published State
    
    @Published var question: Question?
    @Published var posts: [Post] = []
    @Published var isLoading = false
    @Published var isLocked: Bool = false
    @Published var shouldShowPopup: Bool = false
     
    // MARK: - Dependencies
    
    private let homeViewUseCase: HomeViewUseCase
    private let previewMusicUseCase: PreviewMusicUseCase
    weak var coordinator: HomeCoordinator?
    
    // MARK: - Combine

    private var cancellables = Set<AnyCancellable>()
    private var loadTask: Task<Void, Never>?
    private var refreshTask: Task<Void, Never>?
    private var previewTask: Task<Void, Never>?

    deinit {
        loadTask?.cancel()
        refreshTask?.cancel()
        previewTask?.cancel()
    }

    init(
        homeViewUseCase: HomeViewUseCase,
        previewMusicUseCase: PreviewMusicUseCase,
        coordinator: HomeCoordinator?
    ) {
        self.homeViewUseCase = homeViewUseCase
        self.previewMusicUseCase = previewMusicUseCase
        self.coordinator = coordinator
        bindAppEvent()
    }
}

// MARK: - Home Data Loading

extension HomeViewModel {

    func startLoad() {
        loadTask?.cancel()
        loadTask = Task { await loadHome() }
    }

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

// MARK: - AppEvent Binding

private extension HomeViewModel {

    func bindAppEvent() {
        AppEventBus.shared.event
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let self else { return }

                switch event {
                case let .homeShouldRefresh(reason):
                    self.handleHomeRefresh(reason)
                default:
                    break
                }
            }
            .store(in: &cancellables)
    }
    
    func handleHomeRefresh(_ reason: HomeRefreshReason) {
        refreshTask?.cancel()
        refreshTask = Task {
            await loadHome()
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
            AppEventBus.shared.event.send(
                .mypageShouldRefresh(reason: .scrapToggled)
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
        coordinator?.goToMusicCommentDetail(postId: post.id, badge: post.badges)
    }
    
    func goToMonthlyQuestion() {
        coordinator?.goToMonthlyQuestion()
    }
    
    func goToScrapTab() {
        coordinator?.goToScrapTab()
    }
    
    func didTapUserProfile(userId: Int) {
        let myUserId = UserDefaults.standard.integer(forKey: "userId")
        
        if userId == myUserId {
            coordinator?.goToScrapTab()
        } else {
            coordinator?.goToUserProfile(userId: userId)
        }
    }
    
    func goToPostMusicComment() {
        coordinator?.goToPostMusicComment()
    }
}

// MARK: - 음악 재생
extension HomeViewModel {

    func didTapPreview(post: Post, playCellId: UUID) {
        previewTask?.cancel()
        previewTask = Task {
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
