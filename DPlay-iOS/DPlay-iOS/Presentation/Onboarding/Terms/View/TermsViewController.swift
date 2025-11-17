//
//  TermsViewController.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 11/15/25.
//

import UIKit

import SnapKit
import Then

final class TermsViewController: UIViewController {
    
    //MARK: - UI Properties

    private let backButton = UIButton()
    private let titleLabel = UILabel()
    private let termsStackView = UIStackView()
    private let agreeAllButton = AllAgreementButton()
    private let serviceTermView = AgreementItemView()
    private let privacyTermView = AgreementItemView()
    private let nextButton = UIButton()

    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStyle()
        setupHierarchy()
        setupLayout()
    }
}

private extension TermsViewController {
    
    //MARK: - setup
    
    func setupStyle() {
        view.backgroundColor = .white
        
        backButton.do {
            $0.setImage(.isBack48, for: .normal)
        }
        
        titleLabel.do {
            $0.text = "디플레이 이용을 위해\n약관에 동의해주세요"
            $0.setTextStyle(.titleBold24)
            $0.textColor = .dplay_black
            $0.numberOfLines = 2
            $0.textAlignment = .left
        }
        
        termsStackView.do {
            $0.axis = .vertical
            $0.distribution = .fillEqually
        }
        
        serviceTermView.do {
            $0.setTitle("서비스 이용약관 (필수)")
        }
        
        privacyTermView.do {
            $0.setTitle("개인정보 처리방침 (필수)")
        }
        
        nextButton.do {
            $0.setTitle("다음으로", for: .normal)
            $0.setTitleColor(.gray400, for: .normal)
            $0.titleLabel?.setTextStyle(.bodyBold16)
            $0.backgroundColor = .gray200
            $0.roundCorners(cornerRadius: 12)
        }
    }
    
    func setupHierarchy() {
        view.addSubviews(
            backButton,
            titleLabel,
            termsStackView,
            nextButton
        )
        
        termsStackView.addArrangedSubviews(
            agreeAllButton,
            serviceTermView,
            privacyTermView
        )
    }
    
    func setupLayout() {
        backButton.snp.makeConstraints{
            $0.top.leading.equalTo(view.safeAreaLayoutGuide)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(backButton.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(16)
        }
        
        termsStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(40)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(168)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.height.equalTo(61)
        }
    }
}
