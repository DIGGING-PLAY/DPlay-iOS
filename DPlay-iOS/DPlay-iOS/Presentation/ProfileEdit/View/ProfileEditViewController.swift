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
    
    private var editButtonBottomConstraint: Constraint?
    private var initialNickname: String?
    private var initialProfileImage: UIImage?

    //MARK: - UI Properties

    private let navigationBarView = ProfileEditNavigationBarView()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let imageSelectButton = ProfileImageSelectButton()
    private let nicknameTextField = UITextField()
    private let clearButton = UIButton()
    private let textLengthLabel = UILabel()
    private let nicknameDescriptionLabel = UILabel()
    private let editButton = UIButton()

    //MARK: - Life Cycle
    
    init(viewModel: ProfileEditViewModel) {
        self.viewModel = viewModel
        self.initialNickname = viewModel.nickname
        self.initialProfileImage = viewModel.profileImg
        
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
        
        imageSelectButton.do {
            if let img = viewModel.profileImg {
                $0.setProfileImage(type: .selectedImage(img))
            }
        }
        
        nicknameTextField.do {
            $0.backgroundColor = .gray100
            $0.textColor = .dplay_black
            $0.tintColor = .dplay_pink
            $0.text = viewModel.nickname
            $0.font = .dplayFont(.bodySemi16)
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

        editButton.do {
            $0.setTitle("수정하기", for: .normal)
            $0.setTitleColor(.gray400, for: .normal)
            $0.titleLabel?.setTextStyle(.bodyBold16)
            $0.backgroundColor = .gray200
            $0.roundCorners(cornerRadius: 12)
            $0.isEnabled = false
        }
    }
    
    func setupHierarchy() {
        view.addSubviews(navigationBarView, scrollView, editButton)
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
            $0.bottom.equalTo(editButton.snp.top)
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
        
        editButton.snp.makeConstraints {
            $0.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.height.equalTo(61)
            
            editButtonBottomConstraint = $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16).constraint
        }
    }
}

@objc private extension ProfileEditViewController {
    
    //MARK: - @objc Method
    
    func handleKeyboard(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
              let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else { return }
        
        let isKeyboardShowing = keyboardFrame.origin.y < UIScreen.main.bounds.height
        let bottomInset = isKeyboardShowing ? keyboardFrame.height - view.safeAreaInsets.bottom + 16 : 0
        
        editButtonBottomConstraint?.update(inset: bottomInset)
        
        UIView.animate(withDuration: duration,
                       delay: 0,
                       options: UIView.AnimationOptions(rawValue: curve << 16),
                       animations: {
            self.view.layoutIfNeeded()
            
            if isKeyboardShowing {
                let bottomOffset = CGPoint(x: 0,
                                           y: max(self.scrollView.contentSize.height - self.scrollView.bounds.height + self.scrollView.contentInset.bottom, 0))
                self.scrollView.setContentOffset(bottomOffset, animated: true)
            }
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
                self.presentImagePicker()
            },
            secondaryAction: {
                if self.initialProfileImage != nil {
                    self.updateEditButtonState(isEnabled: true)
                }
                self.imageSelectButton.setProfileImage(type: .defaultImage)
                self.viewModel.profileImg = nil
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

    func editButtonTapped() {
        viewModel.startEdittingProfile()
    }
}

private extension ProfileEditViewController {
    
    // MARK: - Private Method
    
    func setupTarget() {
        imageSelectButton.addTarget(self, action: #selector(imageSelectButtonTapped), for: .touchUpInside)
        clearButton.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
    }
    
    func bindNavigationBar() {
        navigationBarView.onTapBackButton = {
            self.viewModel.popToPrevious()
        }
    }
    
    func bindViewModel() {
        viewModel.$nicknameValidationState
            .dropFirst()
            .receive(on: RunLoop.main)
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
            updateEditButtonState(isEnabled: false)
        case .valid:
            editButton.isEnabled = false
        case .normal:
            let isEditted = nicknameTextField.text != initialNickname
            updateEditButtonState(isEnabled: isEditted)
        case .invalid:
            updateEditButtonState(isEnabled: false)
        }
    }
    
    func updateEditButtonState(isEnabled: Bool) {
        editButton.isEnabled = isEnabled
        if isEnabled {
            editButton.setTitleColor(.white, for: .normal)
            editButton.backgroundColor = .dplay_pink
        } else {
            editButton.setTitleColor(.gray400, for: .normal)
            editButton.backgroundColor = .gray200
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
                if let uiImage = object as? UIImage {
                    self.viewModel.profileImg = uiImage
                    self.imageSelectButton.setProfileImage(type: .selectedImage(uiImage))
                    self.updateEditButtonState(isEnabled: true)
                } else {
                    print("프로필 이미지 로드 실패")
                }
            }
        }
    }
}

