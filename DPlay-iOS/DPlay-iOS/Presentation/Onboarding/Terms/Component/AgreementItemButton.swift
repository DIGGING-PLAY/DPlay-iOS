//
//  AgreementItemButton.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 11/15/25.
//

import UIKit

import SnapKit
import Then

final class AgreementItemButton: UIButton {
        
    //MARK: - UI Properties

    private let checkImageView = UIImageView(image: IconLiterals.ic_check_circle_default_24)
    private let itemTitleLabel = UILabel()
    
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

private extension AgreementItemButton {
    
    //MARK: - setup
    
    func setupStyle() {
        itemTitleLabel.do {
            $0.text = " "
            $0.setTextStyle(.bodySemi16)
            $0.textColor = .gray500
        }
    }
    
    func setupHierarchy() {
        addSubviews(
            checkImageView,
            itemTitleLabel
        )
    }
    
    func setupLayout() {
        checkImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(12)
        }
        
        itemTitleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(checkImageView.snp.trailing).offset(12)
        }
    }
}

extension AgreementItemButton {
    
    //MARK: - Method
    
    func setTitle(_ text: String) {
        itemTitleLabel.text = text
    }
    
    func updateUI() {
        checkImageView.image = isSelected ? IconLiterals.ic_check_circle_selected_24 : IconLiterals.ic_check_circle_default_24
    }
}

