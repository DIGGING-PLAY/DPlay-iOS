//
//  CommentGuidePopupView.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 11/25/25.
//

import UIKit

import SnapKit
import Then

final class CommentGuidePopupView: UIView {
    
    // MARK: - UI Properties
    
    private let tailImageView = UIImageView()
    private let containerView = UIView()
    
    private let messageLabel = UILabel()
    private let closeButton = UIButton()
    private let learnMoreButton = UIButton()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) { fatalError() }
}

private extension CommentGuidePopupView {
    
    func setupStyle() {
        backgroundColor = .clear
        
        // 꼬리 이미지
        tailImageView.do {
            $0.image = IconLiterals.ic_polygon
            $0.contentMode = .scaleAspectFit
        }
        
        // 팝업 본체
        containerView.do {
            $0.backgroundColor = .gray600
            $0.roundCorners(cornerRadius: 4)
        }
        
        messageLabel.do {
            $0.text = """
            존중하는 말과 따뜻한 표현을 사용해주세요.
            욕설, 비방, 혐오 발언은 삼가해주세요.
            저작권 문제로 가사 전체 업로드는 불가해요.
            """
            $0.numberOfLines = 0
            $0.setTextStyle(.bodyMedi14)
            $0.textColor = .white
        }
        
        closeButton.do {
            $0.setImage(IconLiterals.ic_close_white, for: .normal)
            $0.tintColor = .white
        }
        
        learnMoreButton.do {
            let text = NSMutableAttributedString(
                string: "더 알아보기",
                attributes: [
                    .underlineStyle: NSUnderlineStyle.single.rawValue,
                    .foregroundColor: UIColor.gray200,
                    .font: UIFont.dplayFont(.capMedi12)
                ]
            )
            $0.setAttributedTitle(text, for: .normal)
        }
    }
    
    func setupHierarchy() {
        addSubviews(tailImageView, containerView)
        containerView.addSubviews(messageLabel, closeButton, learnMoreButton)
    }
    
    func setupLayout() {
        
        // 꼬리 이미지 위치 (containerView와 연결)
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
            $0.top.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().inset(12)
            $0.trailing.equalTo(closeButton.snp.leading).offset(-5)
        }
        
        learnMoreButton.snp.makeConstraints {
            $0.top.equalTo(messageLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview().inset(16)
        }
    }
}

extension CommentGuidePopupView {

    // MARK: - Binding

    func bindActions(close: @escaping () -> Void,
                     learnMore: @escaping () -> Void) {
        closeButton.addAction(UIAction { _ in close() }, for: .touchUpInside)
        learnMoreButton.addAction(UIAction { _ in learnMore() }, for: .touchUpInside)
    }
}
