//
//  MusicDetailNavigationBar.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 11/16/25.
//

import UIKit

import SnapKit
import Then

final class MusicDetailNavigationBar: UIView {
    
    // MARK: - Properties
    
    var onTapBack: (() -> Void)?
    
    // MARK: - UI Properties
    
    private let backButton = UIButton()
    private let dateLabel = UILabel()
    private let menuButton = UIButton()
    
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

private extension MusicDetailNavigationBar {
    func setupStyle() {
        backgroundColor = .clear
        
        backButton.do {
            $0.setImage(ImageLiterals.img_back, for: .normal)
            $0.contentMode = .scaleAspectFit
            $0.tintColor = .black
        }
        
        dateLabel.do {
            $0.text = "10월 12일"
            $0.setTextStyle(.titleBold18)
            $0.textColor = .black
        }
        
        menuButton.do {
            $0.setImage(ImageLiterals.img_dot_menu, for: .normal)
            $0.tintColor = .black
        }
    }
    
    func setupHierarchy() {
        addSubviews(backButton, dateLabel, menuButton)
    }
    
    func setupLayout() {
        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.size.equalTo(48)
        }
        
        dateLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.equalTo(24)
        }
        
        menuButton.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.size.equalTo(48)
        }
    }
}

@objc private extension MusicDetailNavigationBar {
    
    //MARK: - @objc Method
    
    private func didTapBack() {
        onTapBack?()
    }
}

private extension MusicDetailNavigationBar {
    // MARK: - Private Method
    
    func setupTarget() {
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
    }
}
