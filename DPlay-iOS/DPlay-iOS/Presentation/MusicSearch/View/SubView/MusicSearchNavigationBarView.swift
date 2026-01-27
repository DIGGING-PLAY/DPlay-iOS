//
//  MusicAddNavigationBarView.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 11/24/25.
//

import UIKit

import SnapKit
import Then

final class MusicSearchNavigationBarView: UIView {
    
    // MARK: - Properties
    
    var onTapBack: (() -> Void)?
    
    // MARK: - UI Properties
    
    private let backButton = UIButton()
    private let navigationLabel = UILabel()
    
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

private extension MusicSearchNavigationBarView {
    func setupStyle() {
        backgroundColor = .clear
        
        backButton.do {
            $0.setImage(ImageLiterals.img_back, for: .normal)
            $0.contentMode = .scaleAspectFit
            $0.tintColor = .dplay_black
        }

        navigationLabel.do {
            $0.text = "노래 등록하기"
            $0.setTextStyle(.titleBold18)
            $0.textColor = .dplay_black
        }
    }
    
    func setupHierarchy() {
        addSubviews(backButton, navigationLabel)
    }
    
    func setupLayout() {
        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.size.equalTo(48)
        }
        
        navigationLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.equalTo(24)
        }
    }
}

@objc private extension MusicSearchNavigationBarView {
    
    //MARK: - @objc Method
    
    private func didTapBack() {
        onTapBack?()
    }
}

private extension MusicSearchNavigationBarView {
    // MARK: - Private Method
    
    func setupTarget() {
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
    }
}
