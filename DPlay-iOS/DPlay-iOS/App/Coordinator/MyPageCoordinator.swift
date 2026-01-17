//
//  MyPageCoordinator.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 12/2/25.
//

import UIKit

protocol MyPageCoordinating: AnyObject {
    func goToMusicDetail()
    func pop()
}

final class MyPageCoordinator: Coordinator {

    var childCoordinators: [Coordinator] = []
    let navigationController: UINavigationController
    
    private let myPageService = MyPageServiceImpl()
    private lazy var myPageRepository = DefaultMyPageRepository(service: myPageService)
    private lazy var myPageUseCase = DefaultMyPageUseCase(repository: myPageRepository)

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        //로그인 연결 후 userID 저장해둔 값으로 변경 예정
        let vm = MyPageViewModel(useCase: myPageUseCase, coordinator: self, userId: 17)
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
        let vm = SettingViewModel(pushOn: pushOn, coordinator: self)
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
    func goToMusicDetail() {
        
    }
}
