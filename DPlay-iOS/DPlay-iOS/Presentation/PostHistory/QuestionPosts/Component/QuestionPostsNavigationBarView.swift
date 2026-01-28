//
//  QuestionPostsNavigationBarView.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 12/31/25.
//

import UIKit

import SnapKit
import Then

final class QuestionPostsNavigationBarView: UIView {
    
    // MARK: - Properties
    
    var onTapBackButton: (() -> Void)?
    
    // MARK: - UI Properties
    
    private let backButton = UIButton()
    private let dateLabel = UILabel()
    
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

private extension QuestionPostsNavigationBarView {
    
    //MARK: - Layout
    
    func setupStyle() {
        backgroundColor = .clear
        
        backButton.do {
            $0.setImage(IconLiterals.ic_back_48, for: .normal)
        }
        
        dateLabel.do {
            $0.text = " "
            $0.setTextStyle(.titleBold18)
            $0.textColor = .dplay_black
        }
    }
    
    func setupHierarchy() {
        addSubviews(backButton, dateLabel)
    }
    
    func setupLayout() {
        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.size.equalTo(48)
        }
        
        dateLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.equalTo(24)
        }
    }
}

@objc private extension QuestionPostsNavigationBarView {
    
    //MARK: - @objc Method
    
    func backButtonTapped() {
        onTapBackButton?()
    }
}

private extension QuestionPostsNavigationBarView {
    
    // MARK: - Private Method
    
    func setupTarget() {
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
}

extension QuestionPostsNavigationBarView {
    func setDateTitle(_ dateString: String) {
        let input = DateFormatter()
        input.locale = Locale(identifier: "en_US_POSIX")
        input.dateFormat = "yyyy-MM-dd"

        guard let date = input.date(from: dateString) else { return }
        
        let output = DateFormatter()
        output.locale = Locale(identifier: "ko_KR")
        output.dateFormat = "M월 d일"
        
        dateLabel.text = output.string(from: date)
    }
}
