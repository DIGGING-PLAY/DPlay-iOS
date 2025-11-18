//
//  TabBarController.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 11/15/25.
//

import UIKit

import SnapKit
import Then

final class MainTabBarController: UIViewController {
    
    // MARK: - Properties
    
    private var viewControllers: [UIViewController] = []
    private var currentVC: UIViewController?
    
    // MARK: - UI Properties
    
    private let tabBarView = CustomTabBarView() // 내가 만드는 탭바 뷰
    private let containerView = UIView() // 화면 콘텐츠 들어갈 곳
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupHierarchy()
        setupLayout()
        bindActions()
        switchTo(index: 0)
    }
    
    func setViewControllers(_ viewControllers: [UIViewController]) {
        self.viewControllers = viewControllers
        switchTo(index: 0)
    }
}

private extension MainTabBarController {
    
    func setupHierarchy() {
        view.addSubview(containerView)
        view.addSubview(tabBarView)
    }
    
    private func setupLayout() {
        containerView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(tabBarView.snp.top)
        }
        
        tabBarView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(90)
        }
    }
}

private extension MainTabBarController {
    
    // MARK: - Method
    
    private func bindActions() {
        tabBarView.onTapHome = { [weak self] in self?.switchTo(index: 0) }
        tabBarView.onTapMy   = { [weak self] in self?.switchTo(index: 1) }
        tabBarView.onTapAdd  = { [weak self] in /* present something */ }
    }
    
    private func switchTo(index: Int) {
        let selectedVC = viewControllers[index]
        
        if currentVC == selectedVC { return }
        
        // 기존 VC 제거
        if let current = currentVC {
            current.willMove(toParent: nil)
            current.view.removeFromSuperview()
            current.removeFromParent()
        }
        
        // 새로운 VC 추가
        addChild(selectedVC)
        containerView.addSubview(selectedVC.view)
        selectedVC.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        selectedVC.didMove(toParent: self)
        
        currentVC = selectedVC
    }
}
