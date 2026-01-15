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
    private let authService = AuthServiceImpl()
    private lazy var authRepository = DefaultAuthRepository(service: authService)
    private lazy var authUseCase = DefaultAuthUseCase(repository: authRepository)
    
    private let appleIdentityToken: String

    init(navigationController: UINavigationController, appleIdentityToken: String) {
        self.navigationController = navigationController
        self.appleIdentityToken = appleIdentityToken
    }

    func start() {
        let vm = TermsViewModel(coordinator: self)
        let vc = TermsViewController(viewModel: vm)
        navigationController.isNavigationBarHidden = true
        navigationController.setViewControllers([vc], animated: false)
    }
    
    func goToProfileSetting() {
        let vm = ProfileSettingViewModel(
            useCase: authUseCase,
            coordinator: self,
            appleIdentityToken: appleIdentityToken
        )
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

    func goToNotificationPermission() {
        let vm = NotificationPermissionViewModel(coordinator: self)
        let vc = NotificationPermissionViewController(viewModel: vm)
        navigationController.isNavigationBarHidden = true
        navigationController.pushViewController(vc, animated: true)
    }

    func pop() {
        navigationController.popViewController(animated: true)
    }
}
