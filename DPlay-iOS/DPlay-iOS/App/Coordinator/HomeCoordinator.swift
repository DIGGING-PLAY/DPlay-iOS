//
//  HomeCoordinator.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 11/16/25.
//

import UIKit

final class HomeCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    let navigationController: UINavigationController
    
    /// 상위(TabBar)로 네비게이션 요청을 전달하는 클로저
    var onRequestSwitchToMyPage: (() -> Void)?
    
    private let service = MockHomeService()
    private lazy var repository = DefaultHomeRepository(service: service)
    private lazy var useCase = DefaultHomeViewUseCase(repository: repository)
    
    private let postHistoryService = MockPostHistoryService()
    private lazy var postHistoryRepository = DefaultPostHistoryRepository(service: postHistoryService)
    private lazy var postHistoryUseCase = DefaultPostHistoryUseCase(repository: postHistoryRepository)
    
    private let myPageService = MyPageServiceImpl()
    private lazy var myPageRepository = DefaultMyPageRepository(service: myPageService)
    private lazy var myPageUseCase = DefaultMyPageUseCase(repository: myPageRepository)
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        
        // 서버 연결후 Mock 갈아 끼우기
        let homeService: HomeService = MockHomeService()
        let previewService: PreviewNetworkService = PreviewNetworkServiceImpl()
        
        let homeRepository = DefaultHomeRepository(service: homeService)
        let previewRepository = DefaultPreviewMusicRepository(service: previewService)
        
        let homeUseCase = DefaultHomeViewUseCase(repository: homeRepository)
        let previewUseCase = PreviewMusicUseCase(repository: previewRepository)
        
        let viewModel = HomeViewModel(
            homeViewUseCase: homeUseCase,
            previewMusicUseCase: previewUseCase,
            coordinator: self
        )
        
        let vc = HomeViewController(viewModel: viewModel)
        navigationController.isNavigationBarHidden = true
        navigationController.setViewControllers([vc], animated: false)
    }
    
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
    
    func goToMonthlyQuestion() {
        let vm = MonthlyQuestionViewModel(useCase: postHistoryUseCase, coordinator: self)
        let vc = MonthlyQuestionViewController(viewModel: vm)
        navigationController.isNavigationBarHidden = true
        navigationController.rootTabBarController()?.setTabBarHidden(true)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToQuestionPosts() {
        let vm = QuestionPostsViewModel(coordinator: self)
        let vc = QuestionPostsViewController(viewModel: vm)
        navigationController.isNavigationBarHidden = true
        navigationController.rootTabBarController()?.setTabBarHidden(true)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToScrapTab() {
        onRequestSwitchToMyPage?()
    }
    
    func goToUserProfile(userId: Int) {
        let vm = MyPageViewModel(useCase: myPageUseCase, coordinator: self, userId: userId)
        let vc = MyPageViewController(viewModel: vm)
        
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

extension HomeCoordinator: MyPageCoordinating {
    func goToMusicDetail() {
        
    }
}
