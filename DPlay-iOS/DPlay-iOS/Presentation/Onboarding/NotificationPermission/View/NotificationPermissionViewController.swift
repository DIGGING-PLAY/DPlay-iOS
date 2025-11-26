//
//  NotificationPermissionViewController.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 11/25/25.
//

import UIKit

import SnapKit
import Then

final class NotificationPermissionViewController: UIViewController {
    
    //MARK: - Properties
    
    private let viewModel: NotificationPermissionViewModel
        
    //MARK: - UI Properties

    private let logoImageView = UIImageView()
    private let titleLabel = UILabel()
    private let borderView = UIView()
    private let alertIconImageView = UIImageView(image: IconLiterals.ic_alert_24)
    private let alertTitleLabel = UILabel()
    private let alertSubtitleLabel = UILabel()
    private let confirmButton = UIButton()

    //MARK: - Life Cycle
    
    init(viewModel: NotificationPermissionViewModel) {
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

private extension NotificationPermissionViewController {
    
    //MARK: - setup
    
    func setupStyle() {
        view.backgroundColor = .white
        
        logoImageView.do {
            $0.image = ImageLiterals.img_wordmark_pink
                        .resized(to: CGSize(width: 100, height: 30))
                        .withRenderingMode(.alwaysOriginal)
        }
                
        titleLabel.do {
            $0.text = "앱 사용을 위해\n접근 권한을 허용해주세요"
            $0.setTextStyle(.titleBold18)
            $0.textColor = .dplay_black
            $0.numberOfLines = 2
            $0.textAlignment = .center
        }
        
        borderView.do {
            $0.backgroundColor = .clear
            $0.roundCorners(cornerRadius: 12)
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.gray200.cgColor
        }

        confirmButton.do {
            $0.setTitle("확인", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.setTextStyle(.bodyBold16)
            $0.backgroundColor = .dplay_pink
            $0.roundCorners(cornerRadius: 12)
        }
        
        alertTitleLabel.do {
            $0.text = "알림(선택)"
            $0.setTextStyle(.bodyBold14)
            $0.textColor = .dplay_black
            $0.textAlignment = .center
        }

        alertSubtitleLabel.do {
            $0.text = "알림 메세지 제공"
            $0.setTextStyle(.bodyMedi14)
            $0.textColor = .gray400
            $0.textAlignment = .center
        }
    }
    
    func setupHierarchy() {
        view.addSubviews(
            logoImageView,
            titleLabel,
            borderView,
            confirmButton
        )
        
        borderView.addSubviews(
            alertIconImageView,
            alertTitleLabel,
            alertSubtitleLabel
        )
    }
    
    func setupLayout() {
        logoImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(80)
            $0.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(logoImageView.snp.bottom).offset(24)
            $0.centerX.equalToSuperview()
        }
        
        borderView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(32)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(72)
        }
        
        alertIconImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
        }
        
        alertTitleLabel.snp.makeConstraints{
            $0.top.equalTo(alertIconImageView.snp.top)
            $0.leading.equalTo(alertIconImageView.snp.trailing).offset(12)
        }
        
        alertSubtitleLabel.snp.makeConstraints{
            $0.bottom.equalTo(alertIconImageView.snp.bottom)
            $0.leading.equalTo(alertIconImageView.snp.trailing).offset(12)
        }
        
        confirmButton.snp.makeConstraints {
            $0.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.height.equalTo(61)
        }
    }
}

@objc private extension NotificationPermissionViewController {
    
    //MARK: - @objc Method
        
    func confirmButtonTapped() {
        print("confirmButtonTapped")
    }
}

private extension NotificationPermissionViewController {
    
    // MARK: - Private Method
    
    func setupTarget() {
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    }
}
