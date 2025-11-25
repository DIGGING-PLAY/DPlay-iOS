//
//  LoginViewController.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 11/10/25.
//

import UIKit

import SnapKit
import Then

final class LoginViewController: UIViewController {
    
    //MARK: - UI Properties
    
    private let logoStackView = UIStackView()
    private let logoLabel = UILabel()
    private let logoImageView = UIImageView(image: ImageLiterals.img_wordmark_pink)
    private let appleLoginButton = UIButton()
    private let applelogoImageView = UIImageView(image: IconLiterals.ic_apple_24)
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        
        setupTarget()
    }
}

private extension LoginViewController {
    
    //MARK: - setup
    
    func setupStyle() {
        view.backgroundColor = .white
        
        logoStackView.do {
            $0.axis = .vertical
            $0.alignment = .center
            $0.spacing = 8
        }
        
        logoLabel.do {
            $0.text = "새로움을 발견하는 순간"
            $0.setTextStyle(.bodyBold16)
            $0.textColor = .dplay_black
        }
        
        appleLoginButton.do {
            $0.backgroundColor = .dplay_black
            $0.setTitle("Apple로 계속하기", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.setTextStyle(.bodyBold16)
            $0.roundCorners(cornerRadius: 12)
        }
    }
    
    func setupHierarchy() {
        view.addSubviews(logoStackView, appleLoginButton)
        
        logoStackView.addArrangedSubviews(logoLabel, logoImageView)
        
        appleLoginButton.addSubview(applelogoImageView)
    }
    
    func setupLayout() {
        logoStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-99)
        }
        
        appleLoginButton.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.height.equalTo(64)
        }
        
        applelogoImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
        }
    }
}

@objc private extension LoginViewController {
    
    //MARK: - @objc Method
    
    func appleLoginButtonTapped() {
        print("appleLoginButtonTapped")
    }
}

private extension LoginViewController {
    
    // MARK: - Private Method
    
    func setupTarget() {
        appleLoginButton.addTarget(self, action: #selector(appleLoginButtonTapped), for: .touchUpInside)
    }
}
