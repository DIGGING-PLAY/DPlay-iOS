//
//  NotificationPermissionViewModel.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 11/26/25.
//

import UIKit
import UserNotifications

final class NotificationPermissionViewModel {
    
    //MARK: - Dependencies
    
    private let useCase: AuthUseCase
    weak var coordinator: OnboardingCoordinator?
    
    //MARK: - Init
    
    init(useCase: AuthUseCase, coordinator: OnboardingCoordinator?) {
        self.useCase = useCase
        self.coordinator = coordinator
    }
}

extension NotificationPermissionViewModel {
    
    //MARK: - Method
    
    func showPushPermissionAlert() {
        let center = UNUserNotificationCenter.current()
        
        center.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                // 아직 한 번도 권한 팝업을 띄운 적 없을 때만 시스템 Alert 호출
                center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
                    if let error { print("Push permission error:", error) }
                    
                    Task {
                        if granted { //허용 선택한 경우
                            try await self.useCase.setNotification(pushOn: true)
                            await UIApplication.shared.registerForRemoteNotifications()
                        } else { //허용 안 함 선택한 경우
                            try await self.useCase.setNotification(pushOn: false)
                        }
                    }
                }
                
            case .denied:
                // 이미 거부됨 → 시스템 Alert 재표시 불가, 설정 화면 유도 필요
                break
                
            case .authorized, .provisional, .ephemeral:
                // 이미 허용/임시허용 상태
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
                
            @unknown default:
                break
            }
        }
    }
}

extension NotificationPermissionViewModel {
    
    // MARK: - Coordinator
    
    func goToHome() {
        coordinator?.goToMainTabBar()
    }
}
