//
//  MypageNavigationBarView.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 11/27/25.
//

import UIKit

import SnapKit
import Then

final class MypageNavigationBarView: UIView {
    
    // MARK: - Properties
    
    var onTapSettingButton: (() -> Void)?
    
    // MARK: - UI Properties
    
    private let navigationTitle = UILabel()
    private let settingButton = UIButton()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        
        setupTarget()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension MypageNavigationBarView {
    func setupStyle() {
        backgroundColor = .clear
        
        navigationTitle.do {
            $0.text = "마이페이지"
            $0.setTextStyle(.titleBold18)
            $0.textColor = .dplay_black
        }
        
        settingButton.do {
            $0.setImage(IconLiterals.ic_setting_24, for: .normal)
        }
    }
    
    func setupHierarchy() {
        addSubviews(navigationTitle, settingButton)
    }
    
    func setupLayout() {
        navigationTitle.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        settingButton.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.size.equalTo(48)
        }
    }
}

@objc private extension MypageNavigationBarView {
    
    //MARK: - @objc Method
    
    private func settingButtonTapped() {
        onTapSettingButton?()
    }
}

private extension MypageNavigationBarView {
    // MARK: - Private Method
    
    func setupTarget() {
        settingButton.addTarget(self, action: #selector(settingButtonTapped), for: .touchUpInside)
    }
}
