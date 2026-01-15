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
    
    //MARK: - Constraints
    
    private let tabBarHeight: CGFloat = 90
    private var containerBottomConstraint: Constraint?
    private var tabBarBottomConstraint: Constraint?
    
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
            
            containerBottomConstraint = $0.bottom.equalToSuperview().inset(tabBarHeight).constraint
        }
        
        tabBarView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(tabBarHeight)

            tabBarBottomConstraint = $0.bottom.equalToSuperview().constraint
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

extension MainTabBarController {
    func setTabBarHidden(_ hidden: Bool, animated: Bool = true) {
        let inset = hidden ? 0 : tabBarHeight
        let bottomOffset = hidden ? (tabBarHeight + view.safeAreaInsets.bottom) : 0
        
        if tabBarView.isHidden == hidden { return }
        
        //제약 조건 업데이트
        containerBottomConstraint?.update(inset: inset)
        tabBarBottomConstraint?.update(offset: bottomOffset)
        
        tabBarView.isHidden = false
        
        // 탭바를 화면 밖으로 내림(숨김) / 원위치(표시)
        tabBarBottomConstraint?.update(inset: hidden ? -90 : 0)
        
        let animations = {
            self.tabBarView.alpha = hidden ? 0 : 1
            self.view.layoutIfNeeded()
        }
        
        let completion: (Bool) -> Void = { _ in
            self.tabBarView.isHidden = hidden
        }
        
        if animated {
            UIView.animate(withDuration: 0.25,
                           delay: 0,
                           options: [.curveEaseInOut, .allowUserInteraction],
                           animations: animations,
                           completion: completion)
        } else {
            animations()
            completion(true)
        }
    }
}

extension MainTabBarController {

    /// 외부(Coordinator)에서 탭 전환용
    func select(index: Int) {
        guard index >= 0, index < viewControllers.count else { return }
        switchTo(index: index)
        tabBarView.updateSelected(index)
    }
}
