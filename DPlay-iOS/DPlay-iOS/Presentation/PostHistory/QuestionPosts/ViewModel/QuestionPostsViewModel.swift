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
    
    @Published var sample: QuestionPostsDataDTO?

    //MARK: - Dependencies
    
    weak var coordinator: HomeCoordinator?
    
    //MARK: - Init
    
    init(
        coordinator: HomeCoordinator?
    ) {
        self.coordinator = coordinator
    }
}

extension QuestionPostsViewModel {
    
    //MARK: - Method
    
    func loadQuestionPosts() async {
        sample = MockQuestionPosts.sample
    }
}

extension QuestionPostsViewModel {
    
    // MARK: - Coordinator
    
    func popToPrevious() {
        coordinator?.pop()
    }
}
