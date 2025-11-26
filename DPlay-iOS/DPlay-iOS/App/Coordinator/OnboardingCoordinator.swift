//
//  OnboardingCoordinator.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 11/22/25.
//

import UIKit

final class OnboardingCoordinator: Coordinator {

    var childCoordinators: [Coordinator] = []
    let navigationController: UINavigationController
    
    //auth
    private let authService = MockAuthService()
    private lazy var authRepository = DefaultAuthRepository(service: authService)
    private lazy var authUseCase = DefaultAuthUseCase(repository: authRepository)

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vm = TermsViewModel(coordinator: self)
        let vc = TermsViewController(viewModel: vm)
        navigationController.isNavigationBarHidden = true
        navigationController.setViewControllers([vc], animated: false)
    }
    
    func goToProfileSetting() {
        let vm = ProfileSettingViewModel(useCase: authUseCase, coordinator: self)
        let vc = ProfileSettingViewController(viewModel: vm)
        navigationController.isNavigationBarHidden = true
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToOverview() {
        let vm = OverviewViewModel(coordinator: self)
        let vc = OverviewViewController(viewModel: vm)
        navigationController.isNavigationBarHidden = true
        navigationController.pushViewController(vc, animated: true)
    }

    func pop() {
        navigationController.popViewController(animated: true)
    }
}
