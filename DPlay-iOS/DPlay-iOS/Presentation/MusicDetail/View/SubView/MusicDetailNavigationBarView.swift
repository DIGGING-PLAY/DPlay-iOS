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
    
    // MARK: - UI Properties
    
    private let backButton = UIButton().then {
        $0.setImage(ImageLiterals.img_back, for: .normal)
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .black
    }
    
    private let DateLabel = UILabel().then {
        $0.text = "10월 12일"
        $0.font = .dplayFont(.titleBold18)
        $0.textColor = .black
    }
    
    private let menuButton = UIButton().then {
        $0.setImage(ImageLiterals.img_dot_menu, for: .normal)
        $0.tintColor = .black
    }
    
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

private extension MusicDetailNavigationBar {
    func setupStyle() {
        backgroundColor = .clear
    }
    
    func setupHierarchy() {
        addSubviews(backButton, DateLabel, menuButton)
    }
    
    func setupLayout() {
        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(24)
        }
        
        DateLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()  
            $0.centerY.equalToSuperview()
            $0.height.equalTo(24)
        }
        
        menuButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }
    }
}
