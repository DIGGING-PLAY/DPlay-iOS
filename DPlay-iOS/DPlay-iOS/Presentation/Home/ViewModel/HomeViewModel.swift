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
            let (q, p) = try await useCase.getHomeData()
            self.question = q
            self.posts = p
        } catch {
            print("ERROR:", error)
        }
    }
    
    func didSelectPost(_ post: Post) {
        coordinator?.goToDetail(post)
    }
}
