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

    private let service = MockHomeService()  // or DefaultHomeService()
    private lazy var repository = DefaultHomeRepository(service: service)
    private lazy var useCase = DefaultHomeViewUseCase(repository: repository)

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vm = HomeViewModel(useCase: useCase, coordinator: self)
        let vc = HomeViewController(viewModel: vm)
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
        navigationController.pushViewController(vc, animated: true)
    }
    
    func pop() {
        navigationController.popViewController(animated: true)
    }
}
