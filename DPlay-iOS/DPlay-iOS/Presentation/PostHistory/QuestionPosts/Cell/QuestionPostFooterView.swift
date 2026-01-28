//
//  QuestionPostFooterView.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 1/28/26.
//

import UIKit

import SnapKit
import Then

final class QuestionPostFooterView: UIView {
        
    // MARK: - UI Properties
    
    private let guideButton = UIButton()
    private let tooltipView = QuestionPostsGuideTooltipView()
    
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

private extension QuestionPostFooterView {
    
    //MARK: - Layout
    
    func setupStyle() {
        backgroundColor = .clear
        
        guideButton.do {
            $0.setImage(ImageLiterals.img_history_guide, for: .normal)
        }
        
        tooltipView.alpha = 0
    }
    
    func setupHierarchy() {
        addSubviews(guideButton, tooltipView)
    }
    
    func setupLayout() {
        guideButton.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        
        tooltipView.snp.makeConstraints {
            $0.top.equalTo(guideButton.snp.bottom).offset(8)
            $0.leading.equalToSuperview()
        }
    }
}

@objc private extension QuestionPostFooterView {
    
    //MARK: - @objc Method
    
    func guideButtonTapped() {
        UIView.animate(withDuration: 0.25) {
            self.tooltipView.alpha = 1
        }
    }
    
    func tooltipCloseButtonTapped() {
        UIView.animate(withDuration: 0.25) {
            self.tooltipView.alpha = 0
        }
    }
}

private extension QuestionPostFooterView {
    
    // MARK: - Private Method
    
    func setupTarget() {
        guideButton.addTarget(self, action: #selector(guideButtonTapped), for: .touchUpInside)
        tooltipView.closeButton.addTarget(self, action: #selector(tooltipCloseButtonTapped), for: .touchUpInside)
    }
}
