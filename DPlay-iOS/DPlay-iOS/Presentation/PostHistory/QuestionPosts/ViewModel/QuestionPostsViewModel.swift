//
//  QuestionPostsViewModel.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 12/31/25.
//

import SwiftUI
import Combine

@MainActor
final class QuestionPostsViewModel: ObservableObject {
    
    //MARK: - Properties
    
    @Published var questionPosts: QuestionPosts?

    //MARK: - Dependencies
    
    private let useCase: PostHistoryUseCase
    weak var coordinator: HomeCoordinator?
    
    //MARK: - Init
    
    init(
        useCase: PostHistoryUseCase,
        coordinator: HomeCoordinator?
    ) {
        self.useCase = useCase
        self.coordinator = coordinator
    }
}

extension QuestionPostsViewModel {
    
    //MARK: - Method
    
    func loadQuestionPosts() async {
        do {
            let result = try await useCase.getQuestionPosts(questionId: 1)
            
            self.questionPosts = result
        } catch {
            print("ERROR:", error)
        }
    }
}

extension QuestionPostsViewModel {
    
    // MARK: - Coordinator
    
    func popToPrevious() {
        coordinator?.pop()
    }
}
