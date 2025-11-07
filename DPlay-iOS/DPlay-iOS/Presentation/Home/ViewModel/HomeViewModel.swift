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
    @Published var todayQuestion: Question?
    @Published var recommendations: [Recommendation] = []
    
    private let homeUseCase: HomeViewUseCase
    
    init(homeUseCase: HomeViewUseCase) {
        self.homeUseCase = homeUseCase
    }
    
    func loadHome() async {
        do {
            todayQuestion = try await homeUseCase.fetchTodayQuestion()
            let hasUserPosted = false
            recommendations = try await homeUseCase.fetchTodayRecommendations(hasUserPosted: hasUserPosted)
        } catch {
            print("🚨 Error: \(error)")
        }
    }
}
