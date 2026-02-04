//
//  CustomTabBarView.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 11/15/25.
//

import UIKit

import Then
import SnapKit

final class CustomTabBarView: UIView {
    
    // MARK: - Properties
    
    private var selectedIndex: Int = 0
    private let homeDefault = IconLiterals.ic_tabbar_home
    private let homeSelected = IconLiterals.ic_tabbar_home_select
    private let myDefault = IconLiterals.ic_tabbar_mypage
    private let mySelected = IconLiterals.ic_tabbar_mypage_select
    
    var onTapHome: (() -> Void)?
    var onTapAdd: (() -> Void)?
    var onTapMy: (() -> Void)?
    
    // MARK: - UI Properties
    
    private let backgroundView = UIView()
    private let homeButton = UIButton()
    private let addButton = UIButton()
    private let myButton = UIButton()
    private let homeTouchView = UIView()
    private let myTouchView = UIView()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupTarget()
        updateSelected(0)
    }
    
    required init?(coder: NSCoder) { fatalError() }
}

private extension CustomTabBarView {
    
    func setupStyle() {
        backgroundView.do {
            $0.backgroundColor = .white
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.gray200.cgColor
            $0.roundCorners(cornerRadius: 20)
        }
        
        homeButton.do {
            var config = UIButton.Configuration.plain()
            config.image = IconLiterals.ic_tabbar_home
            config.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 48, bottom: 15, trailing: 48)
            $0.configuration = config
            $0.imageView?.contentMode = .scaleAspectFill
        }
        
        addButton.do {
            $0.backgroundColor = .gray600
            $0.roundCorners(cornerRadius: 28)
            $0.setImage(IconLiterals.ic_floating, for: .normal)
        }
        
        myButton.do {
            var config = UIButton.Configuration.plain()
            config.image = IconLiterals.ic_tabbar_mypage
            config.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 48, bottom: 15, trailing: 48)
            $0.configuration = config
            $0.imageView?.contentMode = .scaleAspectFill
        }
    }
    
    func setupHierarchy() {
        addSubviews(backgroundView, addButton)
        backgroundView.addSubviews(homeTouchView, myTouchView)
        homeTouchView.addSubview(homeButton)
        myTouchView.addSubview(myButton)
    }
    
    func setupLayout() {
        backgroundView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(100)
        }
        
        addButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(backgroundView.snp.top)
            $0.width.height.equalTo(56)
        }
        
        homeButton.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(32)
        }
        
        homeTouchView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
            $0.width.equalTo(128)
            $0.height.equalTo(56)
        }
        
        myButton.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(32)
        }
        
        myTouchView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
            $0.width.equalTo(128)
            $0.height.equalTo(56)
        }
    }
}

@objc private extension CustomTabBarView {
    
    //MARK: - @objc Method
    
    private func didTapHome() {
        updateSelected(0)
        onTapHome?()
    }
    
    private func didTapMy() {
        updateSelected(1)
        onTapMy?()
    }
    private func didTapAdd() {
        onTapAdd?()
    }
}

private extension CustomTabBarView {
    
    // MARK: - Private Method
    
    func setupTarget() {
        addButton.addTarget(self, action: #selector(didTapAdd), for: .touchUpInside)
        homeTouchView.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(didTapHome))
        )
        myTouchView.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(didTapMy))
        )
    }
    
    /// 기본 hitTest는 부모 뷰의 영역 안에서만 터치를 탐지
    /// 그런데 addButton의 상단 영역은 부모(CustomTabBarView)의 bounds 바깥이라 터치 영역이 작음
    /// 즉 부모 뷰보다 addButton을 우선해서 터치를 처리하도록 강제
    internal override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let convertedPoint = addButton.convert(point, from: self)
        
        // addButton이 터치 영역 안이면 addButton을 반환
        if addButton.point(inside: convertedPoint, with: event) {
            return addButton
        }

        return super.hitTest(point, with: event)
    }
}

extension CustomTabBarView {
    
    // MARK: - Method
    
    func updateSelected(_ index: Int) {
        selectedIndex = index
        
        if index == 0 {
            homeButton.setImage(homeSelected, for: .normal)
            myButton.setImage(myDefault, for: .normal)
        } else {
            homeButton.setImage(homeDefault, for: .normal)
            myButton.setImage(mySelected, for: .normal)
        }
    }
}
