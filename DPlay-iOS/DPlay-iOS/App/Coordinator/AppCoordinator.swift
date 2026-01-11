//
//  AppCoordinator.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 11/16/25.
//

import UIKit

final class AppCoordinator: Coordinator {

    var childCoordinators: [Coordinator] = []

    private let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        let authFlowCoordinator = AuthFlowCoordinator()
        childCoordinators.append(authFlowCoordinator)
        
        // 메인 탭바로 root 교체하는 클로저
        authFlowCoordinator.onFinishAuthFlow = { [weak self, weak authFlowCoordinator] in
            guard let self else { return }
            
            if let authFlowCoordinator {
                self.removeChild(authFlowCoordinator)
            }
            
            self.showMainTabBar()
        }
        
        authFlowCoordinator.start()
        setRootViewController(authFlowCoordinator.rootViewController, animated: false)
    }
}

private extension AppCoordinator {
    func showMainTabBar() {
        let tabBarCoordinator = TabBarCoordinator()
        childCoordinators.append(tabBarCoordinator)
        tabBarCoordinator.start()
        
        setRootViewController(tabBarCoordinator.rootViewController, animated: true)
    }
    
    ///현재 window의 rootViewController를 변경하는 함수
    func setRootViewController(_ vc: UIViewController, animated: Bool) {
        if animated {
            UIView.transition(
                with: window,
                duration: 0.25,
                options: .transitionCrossDissolve,
                animations: { self.window.rootViewController = vc }
            )
        } else {
            window.rootViewController = vc
        }
        window.makeKeyAndVisible()
    }
    
    
    func removeChild(_ coordinator: Coordinator) {
        childCoordinators.removeAll { $0 === coordinator }
    }
}
