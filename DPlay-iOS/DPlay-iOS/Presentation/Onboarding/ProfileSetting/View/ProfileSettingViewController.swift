//
//  ProfileSettingViewController.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 11/17/25.
//

import UIKit

import SnapKit
import Then

final class ProfileSettingViewController: UIViewController {
    
    //MARK: - Properties
    
    private let viewModel: ProfileSettingViewModel
    
    //MARK: - UI Properties

    private let backButton = UIButton()
    private let titleLabel = UILabel()
    private let imageSelectButton = ProfileImageSelectButton()
    private let nicknameTextField = UITextField()
    private let clearButton = UIButton()
    private let textLengthLabel = UILabel()
    private let nicknameDescriptionLabel = UILabel()
    private let joinButton = UIButton()

    //MARK: - Life Cycle
    
    init(viewModel: ProfileSettingViewModel) {
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
        bindViewModel()
    }
}

private extension ProfileSettingViewController {
    
    //MARK: - setup
    
    func setupStyle() {
        view.backgroundColor = .white
        
        backButton.do {
            $0.setImage(IconLiterals.ic_back_48, for: .normal)
        }
        
        titleLabel.do {
             $0.text = "디플레이에서 사용할\n프로필을 완성해주세요"
             $0.setTextStyle(.titleBold24)
             $0.textColor = .dplay_black
             $0.numberOfLines = 2
             $0.textAlignment = .left
         }
        
        nicknameTextField.do {
            $0.backgroundColor = .gray100
            $0.textColor = .dplay_black
            $0.font = .dplayFont(.bodySemi16)
            $0.attributedPlaceholder = NSAttributedString(
                string: "닉네임을 입력해주세요",
                attributes: [
                    .font: UIFont.dplayFont(.bodySemi16),
                    .foregroundColor: UIColor.gray400
                ]
            )
            $0.addPadding(left: 12)
            $0.roundCorners(cornerRadius: 12)

            let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: 53)).then {
                $0.addSubview(clearButton)
            }
            $0.rightView = rightView
            $0.rightViewMode = .always
        }
        
        clearButton.do {
            $0.setImage(IconLiterals.ic_circle_close, for: .normal)
            $0.frame = CGRect(x: 0, y: 0, width: 20, height: 53)
            $0.isHidden = true
        }
        
        textLengthLabel.do {
            $0.text = "0/10"
            $0.setTextStyle(.capMedi12)
            $0.textColor = .gray400
        }
        
        nicknameDescriptionLabel.do {
            $0.text = " "
            $0.setTextStyle(.capMedi12)
        }

        joinButton.do {
            $0.setTitle("가입하기", for: .normal)
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
            imageSelectButton,
            nicknameTextField,
            textLengthLabel,
            nicknameDescriptionLabel,
            joinButton
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
        
        imageSelectButton.snp.makeConstraints {
            $0.size.equalTo(116)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(28)
        }
        
        nicknameTextField.snp.makeConstraints {
            $0.top.equalTo(imageSelectButton.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(53)
        }
        
        textLengthLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameTextField.snp.bottom).offset(7)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        nicknameDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameTextField.snp.bottom).offset(7)
            $0.leading.equalToSuperview().inset(20)
        }
        
        joinButton.snp.makeConstraints {
            $0.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.height.equalTo(61)
        }
    }
}

@objc private extension ProfileSettingViewController {
    
    //MARK: - @objc Method
    
    func imageSelectButtonTapped() {
        print("imageSelectButtonTapped")
    }

    func backButtonTapped() {
        viewModel.popToPrevious()
    }

    func nicknameDidChange(_ textField: UITextField) {
        var text = textField.text ?? ""
        
        if text.count > 10 {
            text = String(text.prefix(10))
            textField.text = text
        }
        
        textLengthLabel.text = "\(text.count)/10"
        clearButton.isHidden = text.isEmpty
        viewModel.updateNicknameInputState(text)
    }

    func clearButtonTapped() {
        nicknameTextField.text = ""
        clearButton.isHidden = true
        viewModel.onValidationStateChanged?(.empty)
    }

    func joinButtonTapped() {
        guard let nickname = nicknameTextField.text else { return }
        
        viewModel.validateNicknameDuplicate(nickname)
    }
}

private extension ProfileSettingViewController {
    
    // MARK: - Private Method
    
    func setupTarget() {
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        imageSelectButton.addTarget(self, action: #selector(imageSelectButtonTapped), for: .touchUpInside)
        nicknameTextField.addTarget(self, action: #selector(nicknameDidChange), for: .editingChanged)
        clearButton.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
        joinButton.addTarget(self, action: #selector(joinButtonTapped), for: .touchUpInside)
    }
    
    func bindViewModel() {
        viewModel.onValidationStateChanged = { [weak self] state in
            guard let self else { return }
            
            switch state {
            case .empty:
                updateJoinButtonState(isEnabled: false)
                nicknameTextField.layer.borderWidth = 0
                nicknameDescriptionLabel.text = ""
                
            case .normal:
                updateJoinButtonState(isEnabled: true)
                nicknameTextField.layer.borderWidth = 0
                nicknameDescriptionLabel.text = ""
                
            case .valid:
                nicknameTextField.layer.borderColor = UIColor.info_blue.cgColor
                nicknameTextField.layer.borderWidth = 1
                
                nicknameDescriptionLabel.text = "사용 가능한 닉네임이에요"
                nicknameDescriptionLabel.textColor = .info_blue
                
            case .invalid(let error):
                updateJoinButtonState(isEnabled: false)
                nicknameTextField.layer.borderColor = UIColor.alert_red.cgColor
                nicknameTextField.layer.borderWidth = 1
                nicknameDescriptionLabel.textColor = .alert_red

                switch error {
                case .invalidLength:
                    nicknameDescriptionLabel.text = "2자 이상 입력해주세요"
                case .invalidCharacters:
                    nicknameDescriptionLabel.text = "특수문자, 띄어쓰기는 사용이 불가능해요"
                case .duplicate:
                    nicknameDescriptionLabel.text = "이미 사용중인 닉네임이에요"
                }
            }
        }
    }
    
    func updateJoinButtonState(isEnabled: Bool) {
        joinButton.isEnabled = isEnabled
        if isEnabled {
            joinButton.setTitleColor(.white, for: .normal)
            joinButton.backgroundColor = .dplay_pink
        } else {
            joinButton.setTitleColor(.gray400, for: .normal)
            joinButton.backgroundColor = .gray200
        }
    }
}
