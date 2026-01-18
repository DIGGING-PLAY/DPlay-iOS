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
    
    //MARK: - Property Wrappers
    
    @Published var questionPosts: QuestionPosts?
    
    //MARK: - Properties
    
    private let questionId: Int

    //MARK: - Dependencies
    
    private let useCase: PostHistoryUseCase
    weak var coordinator: HomeCoordinator?
    
    //MARK: - Init
    
    init(
        useCase: PostHistoryUseCase,
        coordinator: HomeCoordinator?,
        questionId: Int
    ) {
        self.useCase = useCase
        self.coordinator = coordinator
        self.questionId = questionId
    }
}

extension QuestionPostsViewModel {
    
    //MARK: - Method
    
    func loadQuestionPosts() async {
        do {
            let result = try await useCase.getQuestionPosts(questionId: questionId)
            
            self.questionPosts = result
        } catch {
            print("ERROR:", error)
        }
    }
}

extension QuestionPostsViewModel {
    
    // MARK: - Coordinator
    
    func goToMusicDetail(trackId: String) {
        coordinator?.goToMusicDetail(trackId: trackId)
    }
    
    func popToPrevious() {
        coordinator?.pop()
    }
}
