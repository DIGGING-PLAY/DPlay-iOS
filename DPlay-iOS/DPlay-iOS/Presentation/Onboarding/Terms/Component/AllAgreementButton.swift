//
//  AllAgreementButton.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 11/15/25.
//

import UIKit

import SnapKit
import Then

final class AllAgreementButton: UIButton {
        
    //MARK: - UI Properties

    private var checkImageView = UIImageView(image: IconLiterals.ic_check_circle_default_24)
    private let customTitleLabel = UILabel()
    
    //MARK: - Init
    
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

private extension AllAgreementButton {
    
    //MARK: - setup
    
    func setupStyle() {
        backgroundColor = .gray100
        roundCorners(cornerRadius: 12)
        
        customTitleLabel.do {
            $0.text = "네, 모두 동의합니다"
            $0.setTextStyle(.bodySemi16)
            $0.textColor = .dplay_black
        }
    }
    
    func setupHierarchy() {
        addSubviews(checkImageView, customTitleLabel)
    }
    
    func setupLayout() {
        checkImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(12)
        }
        
        customTitleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(checkImageView.snp.trailing).offset(12)
        }
    }
}

extension AllAgreementButton {
    
    //MARK: - Method
    
    func updateUI(agreeAllSelected: Bool) {
        isSelected = agreeAllSelected
        
        if isSelected {
            checkImageView.image = IconLiterals.ic_check_circle_selected_24
            backgroundColor = .dplay_pink100
        } else {
            checkImageView.image = IconLiterals.ic_check_circle_default_24
            backgroundColor = .gray100
        }
    }
}
