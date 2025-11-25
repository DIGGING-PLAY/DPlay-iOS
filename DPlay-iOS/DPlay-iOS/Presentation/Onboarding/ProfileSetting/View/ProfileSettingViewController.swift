//
//  ProfileSettingViewController.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 11/17/25.
//

import UIKit
import Combine

import SnapKit
import Then

final class ProfileSettingViewController: UIViewController {
    
    //MARK: - Properties
    
    private let viewModel: ProfileSettingViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private var signUpButtonBottomConstraint: Constraint?
    
    //MARK: - UI Properties

    private let backButton = UIButton()
    private let titleLabel = UILabel()
    private let imageSelectButton = ProfileImageSelectButton()
    private let nicknameTextField = UITextField()
    private let clearButton = UIButton()
    private let textLengthLabel = UILabel()
    private let nicknameDescriptionLabel = UILabel()
    private let signUpButton = UIButton()

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
        setupDelegate()
        setupKeyboardObserver()
        
        hideKeyboardWhenTappedAround()
        
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
            $0.returnKeyType = .done
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

        signUpButton.do {
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
            signUpButton
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
        
        signUpButton.snp.makeConstraints {
            $0.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.height.equalTo(61)
            
            signUpButtonBottomConstraint = $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16).constraint
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

    func clearButtonTapped() {
        viewModel.nicknameValidationState = .empty
    }

    func signUpButtonTapped() {
        viewModel.startSignUp()
    }
    
    func handleKeyboard(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
              let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else { return }

        let isKeyboardShowing = keyboardFrame.origin.y < UIScreen.main.bounds.height
        let bottomInset = isKeyboardShowing ? keyboardFrame.height - view.safeAreaInsets.bottom + 16 : 0

        signUpButtonBottomConstraint?.update(inset: bottomInset)

        UIView.animate(withDuration: duration,
                       delay: 0,
                       options: UIView.AnimationOptions(rawValue: curve << 16),
                       animations: { self.view.layoutIfNeeded() })
    }
}

private extension ProfileSettingViewController {
    
    // MARK: - Private Method
    
    func setupTarget() {
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        imageSelectButton.addTarget(self, action: #selector(imageSelectButtonTapped), for: .touchUpInside)
        clearButton.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
    }
    
    func setupDelegate() {
        nicknameTextField.delegate = self
    }
    
    func bindViewModel() {
        viewModel.$nicknameValidationState
            .sink { [weak self] state in
                guard let self = self else { return }
                print(state)
                
                updateUI(state: state)
            }
            .store(in: &cancellables)
    }
    
    func updateUI(state: NicknameValidationState) {
        let descriptionText: String = {
            switch state {
            case .empty, .normal:
                return ""
            case .valid:
                return "사용 가능한 닉네임이에요"
            case .invalid(let nicknameError):
                return nicknameError.errorMessage
            }
        }()
        
        let descriptionColor: UIColor = {
            switch state {
            case .empty, .normal:
                return .clear
            case .valid:
                return .info_blue
            case .invalid:
                return .alert_red
            }
        }()

        nicknameDescriptionLabel.text = descriptionText
        nicknameDescriptionLabel.textColor = descriptionColor

        nicknameTextField.layer.borderWidth = 1
        nicknameTextField.layer.borderColor = descriptionColor.cgColor

        switch state {
        case .empty:
            nicknameTextField.text = ""
            viewModel.nickname = ""
            textLengthLabel.text = "0/10"
            clearButton.isHidden = true
            updateSignUpButtonState(isEnabled: false)
        case .valid:
            signUpButton.isEnabled = false
        case .normal:
            updateSignUpButtonState(isEnabled: true)
        case .invalid:
            updateSignUpButtonState(isEnabled: false)
        }
    }
    
    func updateSignUpButtonState(isEnabled: Bool) {
        signUpButton.isEnabled = isEnabled
        if isEnabled {
            signUpButton.setTitleColor(.white, for: .normal)
            signUpButton.backgroundColor = .dplay_pink
        } else {
            signUpButton.setTitleColor(.gray400, for: .normal)
            signUpButton.backgroundColor = .gray200
        }
    }
    
    func setupKeyboardObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleKeyboard(_:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
    }
}

extension ProfileSettingViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        if text.isEmpty {
            viewModel.nicknameValidationState = .empty
        } else {
            if text.count > 10 {
                viewModel.nickname = String(text.prefix(10))
                textField.text = viewModel.nickname
            }
            
            viewModel.nickname = text
            textLengthLabel.text = "\(text.count)/10"
            clearButton.isHidden = text.isEmpty
        }

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
