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
        AppEventBus.shared.event.send(
            .mypageShouldRefresh(reason: .pushNotificationToggled)
        )
    }
    
    func logout() async throws {
        try await useCase.logout()
        coordinator?.goToAuth()
    }
    
    func withdraw() async throws {
        AppleLoginManager.shared.getAuthorizationCode()
        AppleLoginManager.shared.loadAuthorizationCode = { [weak self] code in
            guard let code, let self else { return }

            Task { @MainActor [weak self] in
                guard let self else { return }
                try? await self.useCase.withdraw(appleAuthorizationCode: code)
                self.coordinator?.goToAuth()
            }
        }
    }
}

extension SettingViewModel {
    
    // MARK: - Coordinator
    
    func popToPrevious() {
        coordinator?.pop()
    }
}
