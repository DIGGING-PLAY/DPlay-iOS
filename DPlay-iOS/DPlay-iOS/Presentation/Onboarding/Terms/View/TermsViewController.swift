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
    
    //MARK: - Properties
    
    private let viewModel = TermsViewModel()
    
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
        
        setupTarget()
    }
}

private extension TermsViewController {
    
    //MARK: - setup
    
    func setupStyle() {
        view.backgroundColor = .white
        
        backButton.do {
            $0.setImage(IconLiterals.ic_back_48, for: .normal)
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
            $0.isEnabled = false
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

@objc private extension TermsViewController {
    
    //MARK: - @objc Method
    
    func backButtonTapped() {
        print("backButtonTapped")
    }

    func agreeAllButtonTapped() {
        viewModel.toggleAll()
        applyStateToUI()
    }

    func agreeButtonTapped(_ sender: UIButton) {
        sender == serviceTermView.agreeButton ? viewModel.toggleService() : viewModel.togglePrivacy()
        applyStateToUI()
    }
    
    func termTitleButtonTapped(_ sender: UIButton) {
        print("termTitleButtonTapped")
    }
}

private extension TermsViewController {
    
    // MARK: - Private Method
    
    func setupTarget() {
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        agreeAllButton.addTarget(self, action: #selector(agreeAllButtonTapped), for: .touchUpInside)
        serviceTermView.agreeButton.addTarget(self, action: #selector(agreeButtonTapped(_:)), for: .touchUpInside)
        privacyTermView.agreeButton.addTarget(self, action: #selector(agreeButtonTapped(_:)), for: .touchUpInside)
        serviceTermView.titleButton.addTarget(self, action: #selector(termTitleButtonTapped(_:)), for: .touchUpInside)
        privacyTermView.titleButton.addTarget(self, action: #selector(termTitleButtonTapped(_:)), for: .touchUpInside)
    }
    
    func applyStateToUI() {
        serviceTermView.agreeButton.isSelected = viewModel.serviceAgreed
        privacyTermView.agreeButton.isSelected = viewModel.privacyAgreed
        agreeAllButton.updateUI(agreeAllSelected: viewModel.allAgreed)
        updateNextButtonState(isEnabled: viewModel.allAgreed)
    }
    
    func updateNextButtonState(isEnabled: Bool) {
        nextButton.isEnabled = isEnabled
        if isEnabled {
            nextButton.setTitleColor(.white, for: .normal)
            nextButton.backgroundColor = .dplay_pink
        } else {
            nextButton.setTitleColor(.gray400, for: .normal)
            nextButton.backgroundColor = .gray200
        }
    }
}
