//
//  MyPageSegmentedControl.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 11/27/25.
//

import UIKit

import SnapKit
import Then

final class MyPageSegmentedControl: UIView {
    
    // MARK: - Properties
    
    var onTapRegisteredMusicsButton: (() -> Void)?
    var onTapArchiveButton: (() -> Void)?

    // MARK: - UI Properties
    
    private let registeredMusicsButton = UIButton()
    private let archiveButton = UIButton()
    private let buttonStackView = UIStackView()
    private let lineView = UIView()
    private let highlightedLineView = UIView()

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

private extension MyPageSegmentedControl {
    func setupStyle() {
        backgroundColor = .clear
        
        registeredMusicsButton.do {
            $0.setTitle("등록한 곡", for: .normal)
            $0.setTitleColor(.gray300, for: .normal)
            $0.setTitleColor(.dplay_black, for: .selected)
            $0.titleLabel?.setTextStyle(.bodyBold16)
            $0.isSelected = true
        }

        archiveButton.do {
            $0.setTitle("보관함", for: .normal)
            $0.setTitleColor(.gray300, for: .normal)
            $0.setTitleColor(.dplay_black, for: .selected)
            $0.titleLabel?.setTextStyle(.bodyBold16)
        }
        
        buttonStackView.do {
            $0.axis = .horizontal
            $0.distribution = .fillEqually
        }
        
        lineView.do {
            $0.backgroundColor = .gray200
        }
        
        highlightedLineView.do {
            $0.backgroundColor = .dplay_black
        }
    }
    
    func setupHierarchy() {
        addSubviews(
            buttonStackView,
            lineView,
            highlightedLineView
        )
        
        buttonStackView.addArrangedSubviews(registeredMusicsButton, archiveButton)
    }
    
    func setupLayout() {
        buttonStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(45)
        }
        
        lineView.snp.makeConstraints {
            $0.bottom.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        highlightedLineView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.centerX.equalTo(registeredMusicsButton.snp.centerX)
            $0.height.equalTo(2)
            $0.width.equalTo(116)
        }
    }
}

@objc private extension MyPageSegmentedControl {
    
    //MARK: - @objc Method
    
    func registeredMusicsButtonTapped() {
        onTapRegisteredMusicsButton?()
        
        registeredMusicsButton.isSelected = true
        archiveButton.isSelected = false
        
        highlightedLineView.snp.remakeConstraints {
            $0.bottom.equalToSuperview()
            $0.centerX.equalTo(registeredMusicsButton.snp.centerX)
            $0.height.equalTo(2)
            $0.width.equalTo(116)
        }

        UIView.animate(withDuration: 0.25) {
            self.layoutIfNeeded()
        }
    }
    
    func archiveButtonTapped() {
        onTapArchiveButton?()
        
        archiveButton.isSelected = true
        registeredMusicsButton.isSelected = false

        highlightedLineView.snp.remakeConstraints {
            $0.bottom.equalToSuperview()
            $0.centerX.equalTo(archiveButton.snp.centerX)
            $0.height.equalTo(2)
            $0.width.equalTo(98)
        }

        UIView.animate(withDuration: 0.25) {
            self.layoutIfNeeded()
        }
    }
}

private extension MyPageSegmentedControl {
    
    // MARK: - Private Method
    
    func setupTarget() {
        registeredMusicsButton.addTarget(self, action: #selector(registeredMusicsButtonTapped), for: .touchUpInside)
        archiveButton.addTarget(self, action: #selector(archiveButtonTapped), for: .touchUpInside)
    }
}
