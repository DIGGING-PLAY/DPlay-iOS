//
//  AgreementItemView.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 11/15/25.
//

import UIKit

import SnapKit
import Then

final class AgreementItemView: UIView {
        
    //MARK: - UI Properties

    let agreeButton = UIButton()
    let titleButton = UIButton()
    private let arrowImageView = UIImageView(image: UIImage(resource: .icArrowRight16))
    
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

private extension AgreementItemView {
    
    //MARK: - setup
    
    func setupStyle() {
        agreeButton.do {
            $0.setImage(.icCheckCircleDefault24, for: .normal)
            $0.setImage(.icCheckCircleSelected24, for: .selected)
        }
        
        titleButton.do {
            $0.titleLabel?.setTextStyle(.bodySemi16)
            $0.setTitleColor(.gray500, for: .normal)
        }
    }
    
    func setupHierarchy() {
        addSubviews(
            agreeButton,
            titleButton,
            arrowImageView
        )
    }
    
    func setupLayout() {
        agreeButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(12)
        }
        
        titleButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(agreeButton.snp.trailing).offset(12)
        }

        arrowImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(12)
        }
    }
}

extension AgreementItemView {
    
    //MARK: - Method
    
    func setTitle(_ text: String) {
        titleButton.setTitle(text, for: .normal)
    }
}
