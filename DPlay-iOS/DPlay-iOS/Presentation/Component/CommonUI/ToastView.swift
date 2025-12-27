//
//  ToastView.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 11/27/25.
//

import UIKit

import SnapKit
import Then

final class ToastView: UIView {
    
    // MARK: - UI Properties
    
    private let iconView = UIImageView()
    private let messageLabel = UILabel()
    private let actionButton = UIButton(type: .custom)
    
    // MARK: - Properties
    
    private var actionHandler: (() -> Void)?
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) { fatalError() }
}

// MARK: - Layout

private extension ToastView {
    
    func setupStyle() {
        
        backgroundColor = .gray500
        roundCorners(cornerRadius: 8)
        
        iconView.do {
            $0.image = IconLiterals.ic_check_circle_selected_24
            $0.contentMode = .scaleAspectFit
        }
        
        messageLabel.do {
            $0.textColor = .white
            $0.setTextStyle(.bodyMedi14)
            $0.numberOfLines = 1
        }
        
        actionButton.do {
            $0.setTitleColor(.dplay_pink, for: .normal)
            $0.titleLabel?.setTextStyle(.bodyBold14)
            $0.addTarget(self, action: #selector(didTapAction), for: .touchUpInside)
        }
    }
    
    func setupHierarchy() {
        addSubviews(
            iconView,
            messageLabel,
            actionButton
        )
    }
    
    func setupLayout() {
        iconView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }
        
        messageLabel.snp.makeConstraints {
            $0.leading.equalTo(iconView.snp.trailing).offset(12)
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(actionButton.snp.leading).offset(-12)
        }
        
        actionButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(12)
        }
    }
}

// MARK: - Method

extension ToastView {
    
    /// Toast에 보여질 내용 지정
    func configure(message: String, actionText: String?, action: (() -> Void)?) {
        messageLabel.do {
            $0.text = message
            $0.setTextStyle(.bodyMedi14)
        }
        
        actionButton.do {
            $0.setTitle(actionText, for: .normal)
            $0.titleLabel?.setTextStyle(.bodyBold14)
            $0.isHidden = (actionText == nil)
        }
        
        self.actionHandler = action
    }
}

// MARK: - @objc Method

@objc private extension ToastView {
    func didTapAction() {
        actionHandler?()
    }
}
