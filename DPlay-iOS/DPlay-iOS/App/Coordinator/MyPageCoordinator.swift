//
//  MyPageCoordinator.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 12/2/25.
//

import UIKit

protocol DetailCoordinating: AnyObject {
    func goToMusicCommentDetail(postId: Int, badge: Badge)
    func goToScrapTab()
    func goToUserProfile(userId: Int)
    func pop()
    func popToRoot()
}

final class MyPageCoordinator: Coordinator {

    var childCoordinators: [Coordinator] = []
    let navigationController: UINavigationController
    
    var onUserSessionEnded: (() -> Void)?
    var onRequestSwitchToMyPage: (() -> Void)?
    
    private let myPageService = MyPageServiceImpl()
    private lazy var myPageRepository = DefaultMyPageRepository(service: myPageService)
    private lazy var myPageUseCase = DefaultMyPageUseCase(repository: myPageRepository)
    
    private let authService = AuthServiceImpl()
    private lazy var authRepository = DefaultAuthRepository(service: authService)
    private lazy var authUseCase = DefaultAuthUseCase(repository: authRepository)
    
    private let commentDetailService = MusicDetailNetworkServiceImpl()
    private lazy var commentRepository = DefaultCommentMusicDetailRepository(service: commentDetailService)
    private lazy var commentDetailUseCase = DefaultMusicDetailUseCase(repository: commentRepository)

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let userId = UserDefaults.standard.integer(forKey: "userId")
        let vm = MyPageViewModel(myPageUseCase: myPageUseCase, commentDetailUseCase: commentDetailUseCase, coordinator: self, userId: userId)
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
    
    func goToAuth() {
        onUserSessionEnded?()
    }

    func pop() {
        navigationController.popViewController(animated: true)
        if navigationController.viewControllers.count == 1 {
            navigationController.rootTabBarController()?.setTabBarHidden(false)
        }
    }
}

extension MyPageCoordinator: DetailCoordinating {
    
    func goToScrapTab() {
        navigationController.rootTabBarController()?.setTabBarHidden(false)
        onRequestSwitchToMyPage?()
    }
    
    func goToMusicCommentDetail(postId: Int, badge: Badge) {
        let previewService: PreviewNetworkService = PreviewNetworkServiceImpl()
        let previewRepository = DefaultPreviewMusicRepository(service: previewService)
        let previewUseCase = PreviewMusicUseCase(repository: previewRepository)
        
        let vm = MusicCommentDetailViewModel(postId: postId, initialBadge: badge, commentDetailUseCase: commentDetailUseCase, previewMusicUseCase: previewUseCase, coordinator: self)
        
        let vc = MusicCommentDetailViewController(viewModel: vm)
        navigationController.isNavigationBarHidden = true
        navigationController.rootTabBarController()?.setTabBarHidden(true)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToUserProfile(userId: Int) {
        let vm = MyPageViewModel(myPageUseCase: myPageUseCase, commentDetailUseCase: commentDetailUseCase, coordinator: self, userId: userId)
        let vc = MyPageViewController(viewModel: vm)
        
        navigationController.isNavigationBarHidden = true
        navigationController.rootTabBarController()?.setTabBarHidden(true)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func popToRoot() {
        navigationController.popToRootViewController(animated: false)
    }
}
