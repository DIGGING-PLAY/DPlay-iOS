//
//  SettingViewModel.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 12/10/25.
//

import SwiftUI
import Combine

@MainActor
final class SettingViewModel: ObservableObject {
    
    //MARK: - Property Wrappers
    
    @Published var pushOn: Bool
    
    //MARK: - Dependencies
    
    weak var coordinator: MyPageCoordinator?
    
    //MARK: - Init
    
    init(
        pushOn: Bool,
        coordinator: MyPageCoordinator?
    ) {
        self.pushOn = pushOn
        self.coordinator = coordinator
    }
}

extension SettingViewModel {
    
    // MARK: - Coordinator
    
    func popToPrevious() {
        coordinator?.pop()
    }
}
