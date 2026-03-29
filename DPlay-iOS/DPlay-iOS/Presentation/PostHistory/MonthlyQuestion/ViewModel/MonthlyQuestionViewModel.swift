//
//  MonthlyQuestionViewModel.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 12/31/25.
//

import SwiftUI
import Combine

@MainActor
final class MonthlyQuestionViewModel: ObservableObject {
    
    //MARK: - Properties
    
    private let currentDate = Date()
    
    //MARK: - Property Wrappers
    
    @Published var selectedYear: Int
    @Published var selectedMonth: Int
    @Published var monthlyQuestions: [MonthlyQuestion]?

    //MARK: - Dependencies

    private let useCase: PostHistoryUseCase
    weak var coordinator: HomeCoordinator?
    private var loadTask: Task<Void, Never>?

    deinit {
        loadTask?.cancel()
    }

    //MARK: - Init

    init(
        useCase: PostHistoryUseCase,
        coordinator: HomeCoordinator?
    ) {
        self.useCase = useCase
        self.coordinator = coordinator
        selectedYear = Calendar.current.component(.year, from: currentDate)
        selectedMonth = Calendar.current.component(.month, from: currentDate)
    }
}

extension MonthlyQuestionViewModel {
    
    //MARK: - Method

    func startLoad() {
        loadTask?.cancel()
        loadTask = Task { await loadMonthlyQuestions() }
    }

    func loadMonthlyQuestions() async {
        do {
            let result = try await useCase.getMonthlyQuestions(year: selectedYear, month: selectedMonth)
            
            self.monthlyQuestions = result
        } catch {
            print("ERROR:", error)
            self.monthlyQuestions = []
        }
    }
}

extension MonthlyQuestionViewModel {
    
    // MARK: - Coordinator
    
    func goToQuestionPosts(questionId: Int) {
        coordinator?.goToQuestionPosts(questionId: questionId)
    }
    
    func popToPrevious() {
        coordinator?.pop()
    }
}
