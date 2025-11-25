//
//  MusicDetailViewModel.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 11/18/25.
//

import SwiftUI
import Combine

@MainActor
final class MusicDetailViewModel: ObservableObject {
    
    @Published var detail: MusicDetail?
    
    private let useCase: MusicDetailUseCase
    weak var coordinator: HomeCoordinator?
    private let trackId: String
    
    init(trackId: String, useCase: MusicDetailUseCase,  coordinator: HomeCoordinator?) {
        self.trackId = trackId
        self.useCase = useCase
        self.coordinator = coordinator
    }
    
    func loadDetail() async {
        do {
            detail = try await useCase.getMusicDetail(trackId: trackId)
        } catch {
            print("❌ Detail load failed:", error)
        }
    }
}

// MARK: - Coordinator

extension MusicDetailViewModel {
    func didTapBack() {
        coordinator?.pop()
    }
}
