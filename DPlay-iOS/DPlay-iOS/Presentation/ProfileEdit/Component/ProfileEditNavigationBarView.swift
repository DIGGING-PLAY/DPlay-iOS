//
//  ProfileEditNavigationBarView.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 12/3/25.
//

import UIKit

import SnapKit
import Then

final class ProfileEditNavigationBarView: UIView {
    
    // MARK: - Properties
    
    var onTapBackButton: (() -> Void)?

    // MARK: - UI Properties
    
    private let navigationTitle = UILabel()
    private let backButton = UIButton()
    
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

private extension ProfileEditNavigationBarView {
    func setupStyle() {
        backgroundColor = .clear
        
        navigationTitle.do {
            $0.text = "프로필 수정"
            $0.setTextStyle(.titleBold18)
            $0.textColor = .dplay_black
        }
        
        backButton.do {
            $0.setImage(IconLiterals.ic_back_48, for: .normal)
        }
    }
    
    func setupHierarchy() {
        addSubviews(
            navigationTitle,
            backButton
        )
    }
    
    func setupLayout() {
        navigationTitle.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        backButton.snp.makeConstraints {
            $0.leading.centerY.equalToSuperview()
            $0.size.equalTo(48)
        }
    }
}

@objc private extension ProfileEditNavigationBarView {
    
    //MARK: - @objc Method
    
    private func backButtonTapped() {
        onTapBackButton?()
    }
}

private extension ProfileEditNavigationBarView {
    
    // MARK: - Private Method
    
    func setupTarget() {
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
}
