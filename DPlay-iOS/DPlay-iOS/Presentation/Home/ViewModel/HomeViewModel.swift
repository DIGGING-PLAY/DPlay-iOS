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
    
    func loadHome() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let homeFeed = try await homeViewUseCase.getHomeData()
            self.question = homeFeed.question
            self.isLocked = homeFeed.locked
            self.posts = homeFeed.locked ? Array(homeFeed.posts.prefix(3)) : homeFeed.posts
            
        } catch {
            print("ERROR:", error)
        }
    }
}

// MARK: - Coordinator
extension HomeViewModel {
    func didSelectPost(_ post: Post) {
        coordinator?.goToMusicDetail(trackId: String(post.id))
    }
}

// MARK: - 음악 재생
extension HomeViewModel {

    func didTapPreview(post: Post) {
        Task {
            do {
                let session = try await previewMusicUseCase.execute(
                    trackId: post.track.id,
                    storefront: "kr"
                )

                AudioPlayerManager.shared.playPreview(
                    sessionId: session.sessionId,
                    trackId: session.trackId,
                    streamURL: session.streamURL
                )

            } catch {
                print("미리듣기 실패:", error)
            }
        }
    }
}
