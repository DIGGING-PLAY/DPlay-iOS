//
//  MusicAddCoordinator.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 11/24/25.
//

import UIKit

final class MusicAddCoordinator: Coordinator {

    var childCoordinators: [Coordinator] = []
    let navigationController: UINavigationController
    var onFinishAdd: (() -> Void)?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let musicSearchService: MusicSearchService = MusicSearchNetworkService()
        let musicSearchRepository = DefaultMusicSearchRepository(service: musicSearchService)
        let musicSearchUseCase = DefaultMusicSearchUseCase(repository: musicSearchRepository)
        let vm = MusicSearchViewModel(useCase: musicSearchUseCase, coordinator: self)
        let vc = MusicSearchViewController(viewModel: vm)
        navigationController.isNavigationBarHidden = true
        navigationController.setViewControllers([vc], animated: false)
    }
    
    func goToMusicComment(trackId: String) {
        let musicCommentservice = PostMusicCommentNetworkService()
        let musicCommentRepository = DefaultPostMusicCommentRepository(service: musicCommentservice)
        let musicCommentUseCase = DefaultPostMusicCommentUseCase(repository: musicCommentRepository)
        let vm = MusicCommentViewModel(trackId: trackId, useCase: musicCommentUseCase, coordinator: self)
        let vc = MusicCommentViewController(viewModel: vm)
        navigationController.isNavigationBarHidden = true
        navigationController.pushViewController(vc, animated: true)
    }
    
    func pop() {
        navigationController.popViewController(animated: true)
    }
    
    func dismiss() {
        navigationController.dismiss(animated: true)
    }
}
