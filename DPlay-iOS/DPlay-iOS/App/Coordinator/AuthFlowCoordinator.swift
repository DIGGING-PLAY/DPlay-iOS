//
//  AuthFlowCoordinator.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 1/9/26.
//

import UIKit

final class AuthFlowCoordinator: Coordinator {

    var childCoordinators: [Coordinator] = []
    var rootViewController = UIViewController()
        
    private let authService = AuthServiceImpl()
    private lazy var authRepository = DefaultAuthRepository(service: authService)
    private lazy var authUseCase = DefaultAuthUseCase(repository: authRepository)
    private let router: AppRouter

    init(router: AppRouter) {
        self.router = router
    }
    
    func start() {
        let vc = SplashViewController()
        rootViewController = vc
        
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            startLoginFlow()
        }
    }
}

extension AuthFlowCoordinator {
    private func startLoginFlow() {
        let loginViewModel = LoginViewModel(useCase: authUseCase, coordinator: self)
        let loginViewController = LoginViewController(viewModel: loginViewModel)

        loginViewController.modalPresentationStyle = .fullScreen
        loginViewController.modalTransitionStyle = .crossDissolve
        
        rootViewController.present(loginViewController, animated: true)
    }
    
    func goToMainTabBar() {
        //window의 roorViewController를 변경하기 위해 AppCoordinator에게 요청
        router.goToMainTabBar()
    }
    
    func goToOnboarding(appleIdentityToken: String) {
        router.goToOnboarding(appleIdentityToken: appleIdentityToken)
    }
}
