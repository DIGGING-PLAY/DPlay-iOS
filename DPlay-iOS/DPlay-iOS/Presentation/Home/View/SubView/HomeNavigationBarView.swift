//
//  HomeNavigationBarView.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 11/14/25.
//

import UIKit

import SnapKit
import Then

final class HomeNavigationBarView: UIView {
    
    // MARK: - UI Properties
    
    private let logoImageView = UIImageView()
    private let menuButton = UIButton()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension HomeNavigationBarView {
    func setupStyle() {
        backgroundColor = .white
        
        logoImageView.do {
            $0.image = IconLiterals.ic_dplay_bigLogo
            $0.contentMode = .scaleAspectFit
        }
        
        menuButton.do {
            $0.setImage(IconLiterals.ic_list_24, for: .normal)
            $0.tintColor = .black
        }
    }
    
    func setupHierarchy() {
        addSubviews(logoImageView, menuButton)
    }
    
    func setupLayout() {
        logoImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(24)
        }
        
        menuButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }
    }
}
