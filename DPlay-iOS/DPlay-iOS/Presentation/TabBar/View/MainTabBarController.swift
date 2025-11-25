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
    
    /// add 플로팅 버튼 코디네이터 까지 전달 하기 위한 클로저
    var onTapAdd: (() -> Void)?
    
    // MARK: - UI Properties
    
    private let tabBarView = CustomTabBarView()
    private let containerView = UIView()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupHierarchy()
        setupLayout()
        bindActions()
    }
    
    func setViewControllers(_ viewControllers: [UIViewController]) {
        self.viewControllers = viewControllers
        guard !viewControllers.isEmpty else { return }
        switchTo(index: 0)
    }
}

private extension MainTabBarController {
    
    // MARK: - Setup
    
    func setupHierarchy() {
        view.addSubviews(containerView, tabBarView)
    }
    
    func setupLayout() {
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
    
    // MARK: - Bind
    
    func bindActions() {
        tabBarView.onTapHome = { [weak self] in
            self?.switchTo(index: 0)
        }
        
        tabBarView.onTapMy = { [weak self] in
            self?.switchTo(index: 1)
        }
        
        tabBarView.onTapAdd = { [weak self] in
            self?.onTapAdd?()
        }
    }
    
    // MARK: - Switching Logic
    
    func switchTo(index: Int) {
        let selectedVC = viewControllers[index]
        if currentVC == selectedVC { return }
        
        // 기존 제거
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
