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
    @Published var posts: [QuestionPost] = []
    
    //MARK: - Properties
    
    private let questionId: Int
    private var nextCursor: String?

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
            let result = try await useCase.getQuestionPosts(questionId: questionId, cursor: nil)
            
            self.questionPosts = result
            self.nextCursor = result.nextCursor
            self.posts = result.items
        } catch {
            print("ERROR:", error)
        }
    }
    
    func loadQuestionPostsMore(currentIndex: Int) async {
        guard let cursor = nextCursor,
              currentIndex >= posts.count - 3 else { return }
        
        do {
            let result = try await useCase.getQuestionPosts(questionId: questionId, cursor: cursor)

            posts.append(contentsOf: result.items)
            nextCursor = result.nextCursor
        } catch {
            nextCursor = nil
        }
    }

}

extension QuestionPostsViewModel {
    
    // MARK: - Coordinator
    
    func goToMusicDetail(trackId: String) {
        guard let postId = Int(trackId) else { return }
        coordinator?.goToMusicCommentDetail(postId: postId, badge: .normal)
    }
    
    func popToPrevious() {
        coordinator?.pop()
    }
}
