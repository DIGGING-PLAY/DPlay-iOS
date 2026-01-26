//
//  TabBarCoordinator.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 11/16/25.
//

import UIKit

final class TabBarCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    let rootViewController = MainTabBarController()
    
    func start() {
        
        // 오디오 세션 미리 활성화
        AudioPlayerManager.shared.prepareAudioSession()
        
        // 1) Home Flow
        let homeNav = UINavigationController()
        let homeCoordinator = HomeCoordinator(navigationController: homeNav)
        homeCoordinator.onRequestSwitchToMyPage = { [weak self] in
            self?.switchToMyPageTab()
        }
        homeCoordinator.onRequestGoToPostMusicComment = { [weak self] in
            self?.startAddFlow()
        }
        homeCoordinator.start()
        
        // 2) My Flow
        let myPageNav = UINavigationController()
        let myPageCoordinator = MyPageCoordinator(navigationController: myPageNav)
        myPageCoordinator.start()
        
        childCoordinators = [homeCoordinator, myPageCoordinator]
        
        // 3) TabBarController에 전달
        rootViewController.setViewControllers([
            homeNav,
            myPageNav
        ])
        
        rootViewController.onTapAdd = { [weak self] in
            self?.startAddFlow()
        }
    }
}

private extension TabBarCoordinator {
    
    func startAddFlow() {
        let addNav = UINavigationController()
        let addCoordinator = MusicAddCoordinator(navigationController: addNav)
        childCoordinators.append(addCoordinator)
        addCoordinator.start()

        addNav.modalPresentationStyle = .fullScreen
        rootViewController.present(addNav, animated: true) 
    }
}

extension TabBarCoordinator {
    func switchToMyPageTab() {
        rootViewController.select(index: 1) // MyPage 탭 이동
    }
}
