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
     
    private let useCase: HomeViewUseCase
    weak var coordinator: HomeCoordinator?
    
    init(useCase: HomeViewUseCase, coordinator: HomeCoordinator?) {
        self.useCase = useCase
        self.coordinator = coordinator
    }
    
    func loadHome() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let homeFeed = try await useCase.getHomeData()
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
    
    func goToMonthlyQuestion() {
        coordinator?.goToMonthlyQuestion()
    }
}
