//
//  HomeCoordinator.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 11/16/25.
//

import UIKit

final class HomeCoordinator: Coordinator, DetailCoordinating {
    
    var childCoordinators: [Coordinator] = []
    let navigationController: UINavigationController
    
    /// 상위(TabBar)로 네비게이션 요청을 전달하는 클로저
    var onRequestSwitchToMyPage: (() -> Void)?
    var onRequestGoToPostMusicComment: (() -> Void)?
    
    private let service = MockHomeService()
    private lazy var repository = DefaultHomeRepository(service: service)
    private lazy var useCase = DefaultHomeViewUseCase(repository: repository)
    
    private let postHistoryService = PostHistoryServiceImpl()
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
        let homeService: HomeService = HomeNetworkServiceImpl()
        let previewService: PreviewNetworkService = PreviewNetworkServiceImpl()
        
        let homeRepository = DefaultHomeRepository(service: homeService)
        let previewRepository = DefaultPreviewMusicRepository(service: previewService)
        
        let homeUseCase = DefaultHomeViewUseCase(repository: homeRepository)
        let previewUseCase = PreviewMusicUseCase(repository: previewRepository)
        
        let homeViewModel = HomeViewModel(
            homeViewUseCase: homeUseCase,
            previewMusicUseCase: previewUseCase,
            coordinator: self
        )
        
        let vc = HomeViewController(viewModel: homeViewModel)
        navigationController.isNavigationBarHidden = true
        navigationController.setViewControllers([vc], animated: false)
    }
    
    func goToMusicCommentDetail(postId: Int, badge: Badge) {
        let commentDetailService = MusicDetailNetworkServiceImpl()
        let previewService: PreviewNetworkService = PreviewNetworkServiceImpl()
       
        let commentRepository = DefaultCommentMusicDetailRepository(service: commentDetailService)
        let previewRepository = DefaultPreviewMusicRepository(service: previewService)
       
        let commentDetailUseCase = DefaultMusicDetailUseCase(repository: commentRepository)
        let previewUseCase = PreviewMusicUseCase(repository: previewRepository)
        
        let vm = MusicCommentDetailViewModel(postId: postId, initialBadge: badge, commentDetailUseCase: commentDetailUseCase, previewMusicUseCase: previewUseCase, coordinator: self)
        
        let vc = MusicCommentDetailViewController(viewModel: vm)
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
    
    func goToQuestionPosts(questionId: Int) {
        let vm = QuestionPostsViewModel(useCase: postHistoryUseCase, coordinator: self, questionId: questionId)
        let vc = QuestionPostsViewController(viewModel: vm)
        navigationController.isNavigationBarHidden = true
        navigationController.rootTabBarController()?.setTabBarHidden(true)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToScrapTab() {
        navigationController.rootTabBarController()?.setTabBarHidden(false)
        onRequestSwitchToMyPage?()
    }
    
    func goToUserProfile(userId: Int) {
        let vm = MyPageViewModel(useCase: myPageUseCase, coordinator: self, userId: userId)
        let vc = MyPageViewController(viewModel: vm)
        
        navigationController.isNavigationBarHidden = true
        navigationController.rootTabBarController()?.setTabBarHidden(true)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToPostMusicComment() {
        onRequestGoToPostMusicComment?()
    }
    
    func pop() {
        navigationController.popViewController(animated: true)
        if navigationController.viewControllers.count == 1 {
            navigationController.rootTabBarController()?.setTabBarHidden(false)
        }
    }
    
    func popToRoot() {
        navigationController.popToRootViewController(animated: false)
    }
}
