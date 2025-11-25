//
//  MusicAddViewModel.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 11/25/25.
//

import SwiftUI
import Combine

@MainActor
final class MusicAddViewModel: ObservableObject {

    weak var coordinator: MusicAddCoordinator?
    
    init(coordinator: MusicAddCoordinator?) {
        self.coordinator = coordinator
    }
}

// MARK: - Coordinator

extension MusicAddViewModel {
    func didTapBack() {
        coordinator?.dismiss()
    }
}
