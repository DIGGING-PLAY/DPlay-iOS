//
//  AuthFlowCoordinator.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 1/9/26.
//

import UIKit

final class AuthFlowCoordinator: Coordinator {

    var childCoordinators: [Coordinator] = []
    var rootViewController = UINavigationController()
    
    private let authService = AuthServiceImpl()
    private lazy var authRepository = DefaultAuthRepository(service: authService)
    private lazy var authUseCase = DefaultAuthUseCase(repository: authRepository)
    private let router: AppRouter
    
    init(router: AppRouter) {
        self.router = router
    }
    
    func start() {
        let vc = SplashViewController()
        rootViewController.setViewControllers([vc], animated: true)
        
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            
            if KeychainManager.shared.accessToken != nil {
                let route = try await authUseCase.checkToken()
                
                switch route {
                case .auth:
                    startLoginFlow()
                case .mainTabBar:
                    goToMainTabBar()
                default:
                    break
                }
            }else {
                startLoginFlow()
            }
        }
    }
}

extension AuthFlowCoordinator {
    func startLoginFlow() {
        let loginViewModel = LoginViewModel(useCase: authUseCase, coordinator: self)
        let loginViewController = LoginViewController(viewModel: loginViewModel)
        
        UIView.transition(
            with: rootViewController.view,
            duration: 0.35,
            options: [.transitionCrossDissolve, .allowAnimatedContent],
            animations: {
                self.rootViewController.setViewControllers([loginViewController],
                                                           animated: false)
            }
        )
    }
    
    func goToMainTabBar() {
        //window의 roorViewController를 변경하기 위해 AppCoordinator에게 요청
        router.goToMainTabBar()
    }
    
    func goToOnboarding(appleIdentityToken: String) {
        router.goToOnboarding(appleIdentityToken: appleIdentityToken)
    }
}
