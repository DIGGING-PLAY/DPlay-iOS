//
//  OverviewViewModel.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 11/26/25.
//

final class OverviewViewModel {
    
    //MARK: - Properties
    
    weak var coordinator: OnboardingCoordinator?
    
    //MARK: - Init
    
    init(coordinator: OnboardingCoordinator?) {
        self.coordinator = coordinator
    }
}

extension OverviewViewModel {
    
    // MARK: - Coordinator

    func goToNotificationPermission() {
        coordinator?.goToNotificationPermission()
    }
    
    func popToPrevious() {
        coordinator?.pop()
    }
}
