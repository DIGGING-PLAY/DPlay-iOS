//
//  MyPageCoordinator.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 12/2/25.
//

import UIKit

final class MyPageCoordinator: Coordinator {

    var childCoordinators: [Coordinator] = []
    let navigationController: UINavigationController
    
    private let myPageService = MockMyPageService()
    private lazy var myPageRepository = DefaultMyPageRepository(service: myPageService)
    private lazy var myPageUseCase = DefaultMyPageUseCase(repository: myPageRepository)

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vm = MyPageViewModel(useCase: myPageUseCase, coordinator: self)
        let vc = MyPageViewController(viewModel: vm)
        navigationController.isNavigationBarHidden = true
        navigationController.setViewControllers([vc], animated: false)
    }
    
    func goToProfileEdit() {
        let vm = ProfileEditViewModel(useCase: myPageUseCase, coordinator: self)
        let vc = ProfileEditViewController(viewModel: vm)
        navigationController.isNavigationBarHidden = true
        navigationController.pushViewController(vc, animated: true)
    }

    func pop() {
        navigationController.popViewController(animated: true)
    }
}
