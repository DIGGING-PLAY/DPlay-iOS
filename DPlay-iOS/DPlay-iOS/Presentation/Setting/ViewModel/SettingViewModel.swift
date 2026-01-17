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
    
    private let useCase: AuthUseCase
    weak var coordinator: MyPageCoordinator?
    
    //MARK: - Init
    
    init(
        pushOn: Bool,
        coordinator: MyPageCoordinator?,
        useCase: AuthUseCase
    ) {
        self.pushOn = pushOn
        self.coordinator = coordinator
        self.useCase = useCase
    }
}

extension SettingViewModel {
    
    //MARK: - Method
    
    func setNotification(pushOn: Bool) async throws {
        try await useCase.setNotification(pushOn: pushOn)
    }
    
    func logout() async throws {
        try await useCase.logout()
    }
    
    func withdraw() async throws {
        try await useCase.withdraw()
    }
}

extension SettingViewModel {
    
    // MARK: - Coordinator
    
    func popToPrevious() {
        coordinator?.pop()
    }
}
