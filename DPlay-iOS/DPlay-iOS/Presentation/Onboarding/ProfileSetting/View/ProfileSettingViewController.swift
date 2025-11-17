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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStyle()
        setupHierarchy()
        setupLayout()
    }
}

private extension ProfileSettingViewController {
    
    //MARK: - setup
    
    func setupStyle() {
        view.backgroundColor = .white
        
        backButton.do {
            $0.setImage(.isBack48, for: .normal)
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
                string: "이메일을 입력하세요",
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
            $0.setImage(.btnCircleClose, for: .normal)
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
