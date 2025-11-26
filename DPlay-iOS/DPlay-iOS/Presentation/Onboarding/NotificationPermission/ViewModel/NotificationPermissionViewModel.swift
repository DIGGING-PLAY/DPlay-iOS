//
//  NotificationPermissionViewModel.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 11/26/25.
//

final class NotificationPermissionViewModel {
    
    //MARK: - Properties
    
    weak var coordinator: OnboardingCoordinator?
    
    //MARK: - Init
    
    init(coordinator: OnboardingCoordinator?) {
        self.coordinator = coordinator
    }
}

extension NotificationPermissionViewModel {
    
    // MARK: - Coordinator

    func goToHome() {
        
    }
}
