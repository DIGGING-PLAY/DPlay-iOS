//
//  MonthlyQuestionNavigationBarView.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 12/30/25.
//

import UIKit

import SnapKit
import Then

final class MonthlyQuestionNavigationBarView: UIView {
    
    // MARK: - Properties
    
    var onTapBackButton: (() -> Void)?
    var onTapMonthSelectButton: (() -> Void)?

    // MARK: - UI Properties
    
    private let backButton = UIButton()
    private let monthSelectButton = UIButton()
    
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

private extension MonthlyQuestionNavigationBarView {
    func setupStyle() {
        backgroundColor = .clear
        
        backButton.do {
            $0.setImage(IconLiterals.ic_back_48, for: .normal)
        }
        
        monthSelectButton.do {
            var config = UIButton.Configuration.plain()
            
            config.image = IconLiterals.ic_arrow_down
            config.imagePlacement = .trailing
            config.imagePadding = 4
            config.baseForegroundColor = .dplay_black
            config.title = "2025년 10월"
            config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                var out = incoming
                out.font = .dplayFont(.titleBold18)
                return out
            }
            
            $0.configuration = config
        }
    }
    
    func setupHierarchy() {
        addSubviews(
            backButton,
            monthSelectButton
        )
    }
    
    func setupLayout() {
        backButton.snp.makeConstraints {
            $0.leading.centerY.equalToSuperview()
            $0.size.equalTo(48)
        }

        monthSelectButton.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

@objc private extension MonthlyQuestionNavigationBarView {
    
    //MARK: - @objc Method
    
    private func settingButtonTapped() {
        onTapMonthSelectButton?()
    }
    
    private func backButtonTapped() {
        onTapBackButton?()
    }
}

private extension MonthlyQuestionNavigationBarView {
    
    // MARK: - Private Method
    
    func setupTarget() {
        monthSelectButton.addTarget(self, action: #selector(settingButtonTapped), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
}

extension MonthlyQuestionNavigationBarView {
    
    // MARK: - Method
    
    func setMonthButtonTitle(year: Int, month: Int) {
        let yearString = String(year)
        let monthString = String(month)
        
        monthSelectButton.configuration?.title = "\(yearString)년 \(monthString)월"
    }
}
