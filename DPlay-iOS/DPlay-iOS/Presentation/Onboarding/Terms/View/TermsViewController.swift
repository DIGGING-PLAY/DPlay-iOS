//
//  TermsViewController.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 11/15/25.
//

import UIKit

import SafariServices
import SnapKit
import Then

final class TermsViewController: UIViewController {
    
    //MARK: - Properties
    
    private let viewModel: TermsViewModel
    
    //MARK: - UI Properties

    private let backButton = UIButton()
    private let titleLabel = UILabel()
    private let agreeAllButton = AllAgreementButton()
    private let serviceTermButton = AgreementItemButton()
    private let privacyTermButton = AgreementItemButton()
    private let serviceTermRedirectButton = UIButton()
    private let privacyTermRedirectButton = UIButton()
    private let nextButton = UIButton()

    //MARK: - Life Cycle
    
    init(viewModel: TermsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        
        serviceTermButton.do {
            $0.setTitle("서비스 이용약관 (필수)")
        }
        
        privacyTermButton.do {
            $0.setTitle("개인정보 처리방침 (필수)")
        }
        
        serviceTermRedirectButton.do {
            $0.setImage(IconLiterals.ic_arrow_right_16, for: .normal)
        }
        
        privacyTermRedirectButton.do {
            $0.setImage(IconLiterals.ic_arrow_right_16, for: .normal)
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
            agreeAllButton,
            serviceTermButton,
            privacyTermButton,
            serviceTermRedirectButton,
            privacyTermRedirectButton,
            nextButton
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
        
        agreeAllButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(40)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(56)
        }
        
        serviceTermButton.snp.makeConstraints {
            $0.top.equalTo(agreeAllButton.snp.bottom)
            $0.leading.equalToSuperview().inset(16)
            $0.height.equalTo(56)
        }
        
        serviceTermRedirectButton.snp.makeConstraints {
            $0.centerY.equalTo(serviceTermButton)
            $0.leading.equalTo(serviceTermButton.snp.trailing)
            $0.trailing.equalToSuperview().inset(12)
            $0.height.equalTo(56)
            $0.width.equalTo(40)
        }
        
        privacyTermButton.snp.makeConstraints {
            $0.top.equalTo(serviceTermButton.snp.bottom)
            $0.leading.equalToSuperview().inset(16)
            $0.height.equalTo(56)
        }
        
        privacyTermRedirectButton.snp.makeConstraints {
            $0.centerY.equalTo(privacyTermButton)
            $0.leading.equalTo(privacyTermButton.snp.trailing)
            $0.trailing.equalToSuperview().inset(12)
            $0.height.equalTo(56)
            $0.width.equalTo(40)
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
        viewModel.popToPrevious()
    }
    
    func agreeAllButtonTapped() {
        viewModel.toggleAll()
        applyStateToUI()
    }
    
    func agreeButtonTapped(_ sender: AgreementItemButton) {
        sender.isSelected.toggle()
        sender == serviceTermButton ? viewModel.toggleService() : viewModel.togglePrivacy()
        applyStateToUI()
    }
    
    func termTitleButtonTapped(_ sender: UIButton) {
        guard let url = sender == serviceTermRedirectButton ? URL(string: "https://www.notion.so/2d13aeb558c9801fb8c2db2ae6ac2c3e?source=copy_link") : URL(string: "https://www.notion.so/2d13aeb558c98003b480f83b06245430?source=copy_link") else { return }
        
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }
    
    func nextButtonTapped() {
        viewModel.goToProfileSetting()
    }
}

private extension TermsViewController {
    
    // MARK: - Private Method
    
    func setupTarget() {
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        agreeAllButton.addTarget(self, action: #selector(agreeAllButtonTapped), for: .touchUpInside)
        serviceTermButton.addTarget(self, action: #selector(agreeButtonTapped(_:)), for: .touchUpInside)
        privacyTermButton.addTarget(self, action: #selector(agreeButtonTapped(_:)), for: .touchUpInside)
        serviceTermRedirectButton.addTarget(self, action: #selector(termTitleButtonTapped(_:)), for: .touchUpInside)
        privacyTermRedirectButton.addTarget(self, action: #selector(termTitleButtonTapped(_:)), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    func applyStateToUI() {
        serviceTermButton.isSelected = viewModel.serviceAgreed
        privacyTermButton.isSelected = viewModel.privacyAgreed
        serviceTermButton.updateUI()
        privacyTermButton.updateUI()
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
