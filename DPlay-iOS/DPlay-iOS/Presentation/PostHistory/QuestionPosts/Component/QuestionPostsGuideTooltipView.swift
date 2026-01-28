//
//  QuestionPostsGuideTooltipView.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 1/28/26.
//

import UIKit

import SnapKit
import Then

final class QuestionPostsGuideTooltipView: UIView {
    
    // MARK: - UI Properties
    
    private let tailImageView = UIImageView()
    private let containerView = UIView()
    
    private let messageLabel = UILabel()
    let closeButton = UIButton()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) { fatalError() }
}

private extension QuestionPostsGuideTooltipView {
    
    func setupStyle() {
        backgroundColor = .clear
        
        tailImageView.do {
            $0.image = IconLiterals.ic_polygon
            $0.contentMode = .scaleAspectFit
        }
        
        containerView.do {
            $0.backgroundColor = .gray600
            $0.roundCorners(cornerRadius: 4)
        }
        
        messageLabel.do {
            $0.text = """
            이 날의 추천은 여기까지에요.
            곡을 등록하지 않은 날에는 최대 3곡만 보여요.
            """
            $0.numberOfLines = 0
            $0.setTextStyle(.bodyMedi14)
            $0.textColor = .white
        }
        
        closeButton.do {
            $0.setImage(IconLiterals.ic_close_white, for: .normal)
            $0.tintColor = .white
        }
    }
    
    func setupHierarchy() {
        addSubviews(tailImageView, containerView)
        containerView.addSubviews(messageLabel, closeButton)
    }
    
    func setupLayout() {
        tailImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(containerView.snp.leading).offset(50)
            $0.width.equalTo(16)
            $0.height.equalTo(10)
        }
        
        containerView.snp.makeConstraints {
            $0.top.equalTo(tailImageView.snp.bottom).offset(-1)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.trailing.equalToSuperview().inset(12)
            $0.size.equalTo(24)
        }
        
        messageLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().inset(12)
            $0.trailing.equalTo(closeButton.snp.leading).offset(-5)
        }
    }
}
