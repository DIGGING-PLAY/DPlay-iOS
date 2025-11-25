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
        // 1) Home Flow
        let homeNav = UINavigationController()
        let homeCoordinator = HomeCoordinator(navigationController: homeNav)
        homeCoordinator.start()
        
        // 2) My Flow
        //        let myNav = UINavigationController()
        //        let myCoordinator = MyCoordinator(navigationController: myNav)
        //        myCoordinator.start()
        
        childCoordinators = [homeCoordinator]
        
        // 3) TabBarController에 전달
        rootViewController.setViewControllers([
            homeNav,
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
