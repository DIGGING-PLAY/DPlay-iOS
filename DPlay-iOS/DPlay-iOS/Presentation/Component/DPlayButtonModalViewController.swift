//
//  DPlayButtonModalViewController.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 11/26/25.
//

import UIKit

import SnapKit
import Then

enum ModalButtonType {
    case plain
    case warning
}

final class DPlayButtonModalViewController: UIViewController {
    
    //MARK: - Action
    
    private let primaryAction: (() -> Void)?
    private let secondaryAction: (() -> Void)?
    
    //MARK: - Properties
    
    private let type: ModalButtonType
    private let primaryButtonTitle: String
    private let secondaryButtonTitle: String
    private let primaryButtonColor: UIColor
    
    //MARK: - UI Properties
    
    private let primaryButton = UIButton()
    private let secondaryButton = UIButton()
    
    //MARK: - Life Cycle
    
    init(
        type: ModalButtonType,
        primaryButtonTitle: String,
        secondaryButtonTitle: String,
        primaryAction: @escaping (() -> Void),
        secondaryAction: @escaping (() -> Void)
    ) {
        self.type = type
        self.primaryButtonTitle = primaryButtonTitle
        self.secondaryButtonTitle = secondaryButtonTitle
        switch type {
        case .plain:
            primaryButtonColor = .dplay_black
        case .warning:
            primaryButtonColor = .alert_red
        }
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
        
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

private extension DPlayButtonModalViewController {
    
    //MARK: - setup
    
    func setupStyle() {
        view.backgroundColor = .white
        
        primaryButton.do {
            $0.setTitle(primaryButtonTitle, for: .normal)
            $0.setTitleColor(primaryButtonColor, for: .normal)
            $0.titleLabel?.setTextStyle(.bodySemi16)
        }
        
        secondaryButton.do {
            $0.setTitle(secondaryButtonTitle, for: .normal)
            $0.setTitleColor(.gray400, for: .normal)
            $0.titleLabel?.setTextStyle(.capMedi12)
            $0.titleLabel?.setUnderline()
        }
    }
    
    func setupHierarchy() {
        view.addSubviews(primaryButton, secondaryButton)
    }
    
    func setupLayout() {
        primaryButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(53)
        }
        
        secondaryButton.snp.makeConstraints {
            $0.top.equalTo(primaryButton.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(16)
        }
    }
}

@objc private extension DPlayButtonModalViewController {
    
    //MARK: - @objc Method
    
    func primaryButtonTapped() {
        dismiss(animated: true) { [weak self] in
            self?.primaryAction?()
        }
    }
    
    func secondaryButtonTapped() {
        dismiss(animated: true) { [weak self] in
            self?.secondaryAction?()
        }
    }
}

private extension DPlayButtonModalViewController {
    
    // MARK: - Private Method
    
    func setupTarget() {
        primaryButton.addTarget(self, action: #selector(primaryButtonTapped), for: .touchUpInside)
        secondaryButton.addTarget(self, action: #selector(secondaryButtonTapped), for: .touchUpInside)
    }
}
