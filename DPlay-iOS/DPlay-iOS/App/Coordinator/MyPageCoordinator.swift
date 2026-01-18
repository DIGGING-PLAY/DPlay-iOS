//
//  MyPageCoordinator.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 12/2/25.
//

import UIKit

protocol MyPageCoordinating: AnyObject {
    func goToMusicDetail(trackId: String)
    func pop()
}

final class MyPageCoordinator: Coordinator {

    var childCoordinators: [Coordinator] = []
    let navigationController: UINavigationController
    
    private let myPageService = MyPageServiceImpl()
    private lazy var myPageRepository = DefaultMyPageRepository(service: myPageService)
    private lazy var myPageUseCase = DefaultMyPageUseCase(repository: myPageRepository)
    
    private let authService = AuthServiceImpl()
    private lazy var authRepository = DefaultAuthRepository(service: authService)
    private lazy var authUseCase = DefaultAuthUseCase(repository: authRepository)

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let userId = UserDefaults.standard.integer(forKey: "userId")
        let vm = MyPageViewModel(useCase: myPageUseCase, coordinator: self, userId: userId)
        let vc = MyPageViewController(viewModel: vm)
        navigationController.isNavigationBarHidden = true
        navigationController.setViewControllers([vc], animated: false)
    }
    
    func goToProfileEdit(nickname: String, profileImg: UIImage?) {
        let vm = ProfileEditViewModel(nickname: nickname, profileImg: profileImg, useCase: myPageUseCase, coordinator: self)
        let vc = ProfileEditViewController(viewModel: vm)
        navigationController.isNavigationBarHidden = true
        navigationController.rootTabBarController()?.setTabBarHidden(true)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToSetting(pushOn: Bool) {
        let vm = SettingViewModel(pushOn: pushOn, coordinator: self, useCase: authUseCase)
        let vc = SettingViewController(viewModel: vm)
        navigationController.isNavigationBarHidden = true
        navigationController.rootTabBarController()?.setTabBarHidden(true)
        navigationController.pushViewController(vc, animated: true)
    }

    func pop() {
        navigationController.popViewController(animated: true)
        if navigationController.viewControllers.count == 1 {
            navigationController.rootTabBarController()?.setTabBarHidden(false)
        }
    }
}

extension MyPageCoordinator: MyPageCoordinating {
    func goToMusicDetail(trackId: String) {
        let service = MockMusicDetailService()
        let repository = DefaultMusicDetailRepository(service: service)
        let useCase = DefaultMusicDetailUseCase(repository: repository)
        let vm = MusicDetailViewModel(trackId: trackId, useCase: useCase, coordinator: self)
        let vc = MusicDetailViewController(viewModel: vm)
        navigationController.isNavigationBarHidden = true
        navigationController.rootTabBarController()?.setTabBarHidden(true)
        navigationController.pushViewController(vc, animated: true)
    }
}
