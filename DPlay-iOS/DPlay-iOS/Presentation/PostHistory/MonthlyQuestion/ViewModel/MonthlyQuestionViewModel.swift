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
    
    private let currentDate = Date()
    
    //MARK: - Property Wrappers
    
    @Published var selectedYear: Int
    @Published var selectedMonth: Int

    //MARK: - Dependencies
    
    weak var coordinator: HomeCoordinator?
    
    //MARK: - Init
    
    init(
        coordinator: HomeCoordinator?
    ) {
        self.coordinator = coordinator
        selectedYear = Calendar.current.component(.year, from: currentDate)
        selectedMonth = Calendar.current.component(.month, from: currentDate)
    }
}

extension MonthlyQuestionViewModel {
    
    // MARK: - Coordinator
    
    func popToPrevious() {
        coordinator?.pop()
    }
}
