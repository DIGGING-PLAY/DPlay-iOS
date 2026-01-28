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
    private let router: AppRouter

    init(window: UIWindow, router: AppRouter) {
        self.window = window
        self.router = router
    }

    func start() {
        let vc = SplashViewController()
        setRootViewController(vc, animated: true)
        
        router.onRouteChange = { [weak self] route in
            guard let self else { return }
            switch route {
            case .auth:
                self.showAuth()
            case .onboarding(let token):
                self.showOnboardingFlow(appleIdentityToken: token)
            case .mainTabBar:
                self.showMainTabBar()
            }
        }
        
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            showAuth()
        }
    }
}

private extension AppCoordinator {
    func showAuth() {
        let authCoordinator = AuthFlowCoordinator(router: router)
        childCoordinators = [authCoordinator]
        
        authCoordinator.start()
        
        setRootViewController(authCoordinator.rootViewController, animated: true)
    }
    
    func showOnboardingFlow(appleIdentityToken: String) {
        let onboardingNav = UINavigationController()
        let onboardingCoordinator = OnboardingCoordinator(router: router, navigationController: onboardingNav, appleIdentityToken: appleIdentityToken)
        childCoordinators = [onboardingCoordinator]
        
        onboardingCoordinator.start()
        
        setRootViewController(onboardingCoordinator.navigationController, animated: true)
    }
    
    func showMainTabBar() {
        let tabBarCoordinator = TabBarCoordinator(router: router)
        childCoordinators = [tabBarCoordinator]
        tabBarCoordinator.start()
        
        setRootViewController(tabBarCoordinator.rootViewController, animated: true)
    }
    
    ///현재 window의 rootViewController를 변경하는 함수
    func setRootViewController(_ vc: UIViewController, animated: Bool) {
        if animated {
            UIView.transition(
                with: window,
                duration: 0.5,
                options: .transitionCrossDissolve,
                animations: { self.window.rootViewController = vc }
            )
        } else {
            window.rootViewController = vc
        }
        window.makeKeyAndVisible()
    }
}
