//
//  ProfileEditViewController.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 11/17/25.
//

import UIKit
import Combine

import PhotosUI
import SnapKit
import Then

final class ProfileEditViewController: UIViewController {
    
    //MARK: - Properties
    
    private let viewModel: ProfileEditViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private var signUpButtonBottomConstraint: Constraint?
    
    //MARK: - UI Properties

    private let navigationBarView = ProfileEditNavigationBarView()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let imageSelectButton = ProfileImageSelectButton()
    private let nicknameTextField = UITextField()
    private let clearButton = UIButton()
    private let textLengthLabel = UILabel()
    private let nicknameDescriptionLabel = UILabel()
    private let signUpButton = UIButton()

    //MARK: - Life Cycle
    
    init(viewModel: ProfileEditViewModel) {
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
        setupKeyboardObserver()
        
        hideKeyboardWhenTappedAround()
        
        bindViewModel()
        bindNavigationBar()
    }
}

private extension ProfileEditViewController {
    
    //MARK: - setup
    
    func setupStyle() {
        view.backgroundColor = .white
        
        scrollView.do {
            $0.showsVerticalScrollIndicator = false
        }
        
        nicknameTextField.do {
            $0.backgroundColor = .gray100
            $0.textColor = .dplay_black
            $0.tintColor = .dplay_pink
            $0.font = .dplayFont(.bodySemi16)
            $0.attributedPlaceholder = NSAttributedString(
                string: "닉네임을 입력해주세요",
                attributes: [
                    .font: UIFont.dplayFont(.bodySemi16),
                    .foregroundColor: UIColor.gray400
                ]
            )
            $0.returnKeyType = .done
            $0.delegate = self
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
            $0.setTitle("수정하기", for: .normal)
            $0.setTitleColor(.gray400, for: .normal)
            $0.titleLabel?.setTextStyle(.bodyBold16)
            $0.backgroundColor = .gray200
            $0.roundCorners(cornerRadius: 12)
            $0.isEnabled = false
        }
    }
    
    func setupHierarchy() {
        view.addSubviews(navigationBarView, scrollView, signUpButton)
        scrollView.addSubview(contentView)
        contentView.addSubviews(
            imageSelectButton,
            nicknameTextField,
            textLengthLabel,
            nicknameDescriptionLabel
        )
    }
    
    func setupLayout() {
        navigationBarView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(48)
        }

        scrollView.snp.makeConstraints {
            $0.top.equalTo(navigationBarView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(signUpButton.snp.top)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
                
        imageSelectButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.size.equalTo(116)
            $0.centerX.equalToSuperview()
        }
        
        nicknameTextField.snp.makeConstraints {
            $0.top.equalTo(imageSelectButton.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(53)
        }
        
        textLengthLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameTextField.snp.bottom).offset(7)
            $0.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().offset(-20)
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

@objc private extension ProfileEditViewController {
    
    //MARK: - @objc Method
    
    /// 키보드 표시/숨김 변화에 따라 하단 버튼 위치와 스크롤을 조정합니다.
    /// - Parameter notification: 키보드 프레임/애니메이션 정보가 담긴 Notification
    func handleKeyboard(_ notification: Notification) {
        // Notification에서 키보드 최종 프레임, 애니메이션 시간/곡선을 안전하게 추출
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
              let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else { return }
        
        // 키보드가 화면에 올라와 있는지 여부 판단
        let isKeyboardShowing = keyboardFrame.origin.y < UIScreen.main.bounds.height
        // 키보드 높이에 맞춰 하단 버튼(bottom constraint) 인셋 계산 (세이프에리어 보정 + 기본 16 간격)
        let bottomInset = isKeyboardShowing ? keyboardFrame.height - view.safeAreaInsets.bottom + 16 : 0
        // signUpButton의 하단 제약 업데이트
        signUpButtonBottomConstraint?.update(inset: bottomInset)
        
        // 시스템 키보드 애니메이션과 동일한 타이밍/커브로 레이아웃 변경 애니메이션
        UIView.animate(withDuration: duration,
                       delay: 0,
                       options: UIView.AnimationOptions(rawValue: curve << 16),
                       animations: {
            // 레이아웃 변경 반영
            self.view.layoutIfNeeded()
            
            // 키보드가 올라오면 마지막 콘텐츠가 가려지지 않도록 스크롤을 하단으로 이동
            if isKeyboardShowing {
                let bottomOffset = CGPoint(x: 0,
                                           y: max(self.scrollView.contentSize.height - self.scrollView.bounds.height + self.scrollView.contentInset.bottom, 0))
                self.scrollView.setContentOffset(bottomOffset, animated: true)
            }
            // 키보드가 내려가면 스크롤을 초기 위치로 복귀
            else {
                self.scrollView.setContentOffset(.zero, animated: true)
            }
        })
    }
    
    func imageSelectButtonTapped() {
        let modal = DPlayButtonModalViewController(
            type: .plain,
            primaryButtonTitle: "앨범에서 선택하기",
            secondaryButtonTitle: "기본 이미지로 변경하기",
            primaryAction: {
                print("앨범에서 선택하기 탭")
                self.presentImagePicker()
            },
            secondaryAction: {
                print("기본 이미지로 변경하기 탭")
                self.imageSelectButton.setProfileImage(type: .defaultImage)
                self.viewModel.selectedImageData = nil
            }
        )
        
        if let sheet = modal.sheetPresentationController {
            sheet.detents = [
                .custom { _ in 140 }
            ]
            sheet.prefersGrabberVisible = false
        }

        present(modal, animated: true)
    }
    
    func clearButtonTapped() {
        viewModel.nicknameValidationState = .empty
    }

    func signUpButtonTapped() {
        viewModel.startEdittingProfile()
    }
}

private extension ProfileEditViewController {
    
    // MARK: - Private Method
    
    func setupTarget() {
        imageSelectButton.addTarget(self, action: #selector(imageSelectButtonTapped), for: .touchUpInside)
        clearButton.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
    }
    
    func bindNavigationBar() {
        navigationBarView.onTapBackButton = {
            self.viewModel.popToPrevious()
        }
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
    
    func presentImagePicker() {
            var configuration = PHPickerConfiguration()
            configuration.selectionLimit = 1
            configuration.filter = .any(of: [.images])
            
            let picker = PHPickerViewController(configuration: configuration)
            picker.delegate = self
            self.present(picker, animated: true, completion: nil)
        }
}

extension ProfileEditViewController: UITextFieldDelegate {
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

extension ProfileEditViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        guard let provider = results.first?.itemProvider,
              provider.canLoadObject(ofClass: UIImage.self) else {
            return
        }
        
        provider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
            guard let self else { return }
            
            DispatchQueue.main.async {
                if let uiImage = object as? UIImage,
                   let imageData = uiImage.jpegData(compressionQuality: 0.9) {
                    self.viewModel.selectedImageData = imageData
                    self.imageSelectButton.setProfileImage(type: .selectedImage(uiImage))
                } else {
                    print("프로필 이미지 로드 실패")
                }
            }
        }
    }
}

