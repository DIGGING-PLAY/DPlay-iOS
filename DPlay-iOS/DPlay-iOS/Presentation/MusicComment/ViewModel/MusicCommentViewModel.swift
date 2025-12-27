//
//  MusicCommentViewModel.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 11/25/25.
//

import SwiftUI
import Combine

@MainActor
final class MusicCommentViewModel: ObservableObject {

    private let trackId: String
    weak var coordinator: MusicAddCoordinator?
    
    init(trackId: String, coordinator: MusicAddCoordinator?) {
        self.trackId = trackId
        self.coordinator = coordinator
    }
}

// MARK: - Coordinator

extension MusicCommentViewModel {
    func didTapBack() {
        coordinator?.pop()
    }
    
    func didTapRegister(comment: String) {
        coordinator?.dismiss()
    }
}
