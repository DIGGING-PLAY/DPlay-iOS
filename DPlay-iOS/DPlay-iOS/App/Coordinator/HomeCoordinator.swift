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
    
    // MARK: - Dependencies

    private lazy var postHistoryUseCase: PostHistoryUseCase = {
        let service = PostHistoryServiceImpl()
        let repository = DefaultPostHistoryRepository(service: service)
        return DefaultPostHistoryUseCase(repository: repository)
    }()

    private lazy var myPageUseCase: MyPageUseCase = {
        let service = MyPageServiceImpl()
        let repository = DefaultMyPageRepository(service: service)
        return DefaultMyPageUseCase(repository: repository)
    }()
    
    private lazy var authUseCase: AuthUseCase = {
        let service = AuthServiceImpl()
        let repository = DefaultAuthRepository(service: service)
        return DefaultAuthUseCase(repository: repository)
    }()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        
        let homeService: HomeService = HomeNetworkServiceImpl()
        let previewService: PreviewNetworkService = PreviewNetworkServiceImpl()
        
        let homeRepository = DefaultHomeRepository(service: homeService)
        let previewRepository = DefaultPreviewMusicRepository(service: previewService)
        
        let homeUseCase = DefaultHomeViewUseCase(repository: homeRepository)
        let previewUseCase = PreviewMusicUseCase(repository: previewRepository)
        
        let homeViewModel = HomeViewModel(
            authUseCase: authUseCase,
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
        let commentDetailService = MusicDetailNetworkServiceImpl()
        let commentRepository = DefaultCommentMusicDetailRepository(service: commentDetailService)
        let commentDetailUseCase = DefaultMusicDetailUseCase(repository: commentRepository)

        let vm = MyPageViewModel(myPageUseCase: myPageUseCase, commentDetailUseCase: commentDetailUseCase, coordinator: self, userId: userId)
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
