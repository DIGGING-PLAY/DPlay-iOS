//
//  SettingViewController.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 12/10/25.
//

import UIKit
import Combine

import SafariServices
import SnapKit
import Then

final class SettingViewController: UIViewController {

    //MARK: - Properties

    private let viewModel: SettingViewModel
    private var cancellables = Set<AnyCancellable>()

    //MARK: - UI Properties

    private let navigationBarView = SettingNavigationBarView()
    private let pushTitleLabel = UILabel()
    private let pushToggleSwitch = ToggleSwitch()
    private let noticeButton = SettingItemButton(itemType: .notice)
    private let inquiryButton = SettingItemButton(itemType: .inquiry)
    private let dividerView = UIView()
    private let termsOfServiceButton = SettingItemButton(itemType: .termsOfService)
    private let privacyPolicyButton = SettingItemButton(itemType: .privacyPolicy)
    private let appVersionTitleLabel = UILabel()
    private let appVersionLabel = UILabel()
    private let logoutButton = UIButton()
    private let deleteAccountButton = UIButton()

    //MARK: - Life Cycle

    init(viewModel: SettingViewModel) {
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
        bindNavigationBar()
        bindToggleSwitch()
    }
}

private extension SettingViewController {

    //MARK: - setup

    func setupStyle() {
        view.backgroundColor = .white
        
        pushTitleLabel.do {
            $0.text = "푸시 알림"
            $0.setTextStyle(.bodySemi16)
            $0.textColor = .gray600
        }
        
        dividerView.do {
            $0.backgroundColor = .gray100
        }
        
        appVersionTitleLabel.do {
            $0.text = "앱 버전"
            $0.setTextStyle(.bodySemi16)
            $0.textColor = .gray600
        }
        
        appVersionLabel.do {
            $0.text = "v1.0.0"
            $0.setTextStyle(.bodySemi14)
            $0.textColor = .gray400
        }
        
        logoutButton.do {
            $0.setTitle("로그아웃", for: .normal)
            $0.setTitleColor(.alert_red, for: .normal)
            $0.titleLabel?.setTextStyle(.bodySemi16)
        }
        
        deleteAccountButton.do {
            $0.setTitle("회원탈퇴", for: .normal)
            $0.setTitleColor(.gray400, for: .normal)
            $0.titleLabel?.setTextStyle(.capMedi12)
            $0.titleLabel?.setUnderline()
        }
    }

    func setupHierarchy() {
        view.addSubviews(
            navigationBarView,
            pushTitleLabel,
            pushToggleSwitch,
            noticeButton,
            inquiryButton,
            dividerView,
            termsOfServiceButton,
            privacyPolicyButton,
            appVersionTitleLabel,
            appVersionLabel,
            logoutButton,
            deleteAccountButton
        )
    }

    func setupLayout() {
        navigationBarView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(48)
        }
        
        pushTitleLabel.snp.makeConstraints {
            $0.top.equalTo(navigationBarView.snp.bottom)
            $0.leading.equalToSuperview().inset(16)
            $0.height.equalTo(60)
        }
        
        pushToggleSwitch.snp.makeConstraints {
            $0.centerY.equalTo(pushTitleLabel)
            $0.trailing.equalToSuperview().inset(16)
            $0.width.equalTo(52)
            $0.height.equalTo(28)
        }
        
        noticeButton.snp.makeConstraints {
            $0.top.equalTo(pushTitleLabel.snp.bottom)
            $0.width.equalToSuperview()
            $0.height.equalTo(53)
        }
        
        inquiryButton.snp.makeConstraints {
            $0.top.equalTo(noticeButton.snp.bottom)
            $0.width.equalToSuperview()
            $0.height.equalTo(53)
        }
        
        dividerView.snp.makeConstraints {
            $0.top.equalTo(inquiryButton.snp.bottom)
            $0.width.equalToSuperview()
            $0.height.equalTo(8)
        }
        
        termsOfServiceButton.snp.makeConstraints {
            $0.top.equalTo(dividerView.snp.bottom)
            $0.width.equalToSuperview()
            $0.height.equalTo(53)
        }
        
        privacyPolicyButton.snp.makeConstraints {
            $0.top.equalTo(termsOfServiceButton.snp.bottom)
            $0.width.equalToSuperview()
            $0.height.equalTo(53)
        }
        
        appVersionTitleLabel.snp.makeConstraints {
            $0.top.equalTo(privacyPolicyButton.snp.bottom)
            $0.leading.equalToSuperview().inset(16)
            $0.height.equalTo(53)
        }
        
        appVersionLabel.snp.makeConstraints {
            $0.centerY.equalTo(appVersionTitleLabel)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        logoutButton.snp.makeConstraints {
            $0.top.equalTo(appVersionTitleLabel.snp.bottom)
            $0.leading.equalToSuperview().inset(16)
            $0.height.equalTo(53)
        }
        
        deleteAccountButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}

@objc private extension SettingViewController {

    //MARK: - @objc Method

    func toggleSwitchChanged(_ sender: ToggleSwitch) {
        Task {
            try await viewModel.setNotification(pushOn: sender.isOn)
        }
        viewModel.pushOn = sender.isOn
    }
    
    func settingItemButtonTapped(_ sender: SettingItemButton) {
        guard let url = sender.itemType.redirectURL else { return }
        
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }
    
    func logoutButtonTapped() {
        AlertWindowManager.shared.present(
            title: "로그아웃하시겠어요?",
            actions: [
                AlertAction(
                    buttonTitle: "취소",
                    style: .secondaryLeft,
                    onTap: {
                        print("취소 선택")
                    }),
                AlertAction(
                    buttonTitle: "로그아웃",
                    style: .primaryRight,
                    onTap: {
                        print("로그아웃 선택")
                    })
            ],
        )
    }
    
    func deleteAccountButtonTapped() {
        AlertWindowManager.shared.present(
            title: "정말 탈퇴하시겠어요?",
            message: "작성하신 글, 좋아요한 글, 저장한 글 등 모든 기록이 삭제되며 복구가 불가능해요.",
            actions: [
                AlertAction(
                    buttonTitle: "탈퇴하기",
                    style: .secondaryLeft,
                    onTap: {
                        print("탈퇴하기 선택")
                    }),
                AlertAction(
                    buttonTitle: "머무르기",
                    style: .primaryRight,
                    onTap: {
                        print("머무르기 선택")
                    })
            ],
        )
    }
}

private extension SettingViewController {
    
    // MARK: - Private Method
    
    func setupTarget() {
        pushToggleSwitch.addTarget(self, action: #selector(toggleSwitchChanged(_:)), for: .valueChanged)
        noticeButton.addTarget(self, action: #selector(settingItemButtonTapped(_:)), for: .touchUpInside)
        inquiryButton.addTarget(self, action: #selector(settingItemButtonTapped(_:)), for: .touchUpInside)
        termsOfServiceButton.addTarget(self, action: #selector(settingItemButtonTapped(_:)), for: .touchUpInside)
        privacyPolicyButton.addTarget(self, action: #selector(settingItemButtonTapped(_:)), for: .touchUpInside)
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        deleteAccountButton.addTarget(self, action: #selector(deleteAccountButtonTapped), for: .touchUpInside)
    }
    
    func bindNavigationBar() {
        navigationBarView.onTapBackButton = {
            self.viewModel.popToPrevious()
        }
    }
    
    func bindToggleSwitch() {
        pushToggleSwitch.setOn(viewModel.pushOn, animated: false)
    }
}
