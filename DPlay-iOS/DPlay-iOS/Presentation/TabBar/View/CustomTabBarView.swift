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
            $0.layer.cornerRadius = 20
        }
        
        homeButton.do {
            $0.setImage(IconLiterals.ic_tabbar_home, for: .normal)
            $0.imageView?.contentMode = .scaleAspectFill
        }
        
        addButton.do {
            $0.backgroundColor = .gray600
            $0.layer.cornerRadius = 28
            $0.setImage(IconLiterals.ic_floating, for: .normal)
        }
        
        myButton.do {
            $0.setImage(IconLiterals.ic_tabbar_mypage, for: .normal)
            $0.imageView?.contentMode = .scaleAspectFill
        }
    }
    
    func setupHierarchy() {
        addSubviews(backgroundView, addButton)
        backgroundView.addSubviews(homeButton, myButton)
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
            $0.top.equalToSuperview().inset(12)
            $0.leading.equalToSuperview().offset(67.75)
            $0.size.equalTo(32)
        }
        
        myButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.trailing.equalToSuperview().inset(67.75)
            $0.size.equalTo(32)
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
    private func didTapAdd() { onTapAdd?() }
}

private extension CustomTabBarView {
    
    // MARK: - Private Method
    
    func setupTarget() {
        homeButton.addTarget(self, action: #selector(didTapHome), for: .touchUpInside)
        addButton.addTarget(self, action: #selector(didTapAdd), for: .touchUpInside)
        myButton.addTarget(self, action: #selector(didTapMy), for: .touchUpInside)
    }
}

extension CustomTabBarView {
    
    // MARK: - Method
    
    private func updateSelected(_ index: Int) {
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
