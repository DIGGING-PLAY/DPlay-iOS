//
//  AlertViewController.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 12/15/25.
//

import UIKit

import SnapKit
import Then

final class AlertViewController: UIViewController {
    
    // MARK: - Properties
    
    private let titleText: String?
    private let messageText: String?
    private let actions: [AlertAction]
    private let onDismiss: (() -> Void)?
    
    // MARK: - UI Properties
    
    private let dimView = UIView()
    private let containerView = UIView()
    private let warningImageView = UIImageView(image: IconLiterals.ic_warning_40)
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    private let buttonStackView = UIStackView()
    
    // MARK: - Init
    
    init(
        title: String?,
        message: String? = nil,
        actions: [AlertAction],
        onDismiss: (() -> Void)? = nil
    ) {
        self.titleText = title
        self.messageText = message
        self.actions = actions
        self.onDismiss = onDismiss
        
        super.init(nibName: nil, bundle: nil)
        
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupTarget()
        setupButtons()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animateIn()
    }
    
    // MARK: - Layout
    
    private func setupStyle() {
        view.backgroundColor = .clear
        
        dimView.do {
            $0.backgroundColor = .dim80
        }
        
        containerView.do {
            $0.backgroundColor = .white
            $0.roundCorners(cornerRadius: 12)
            $0.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
            $0.alpha = 0
        }
        
        titleLabel.do {
            $0.text = titleText
            $0.setTextStyle(.bodyBold16)
            $0.textColor = .dplay_black
            $0.textAlignment = .center
            $0.numberOfLines = 0
        }
        
        messageLabel.do {
            $0.text = messageText
            $0.setTextStyle(.bodyMedi14)
            $0.textColor = .gray400
            $0.textAlignment = .center
            $0.numberOfLines = 0
        }
        
        buttonStackView.do {
            $0.axis = .horizontal
            $0.spacing = 0
            $0.distribution = .fillEqually
        }
        
        //접근성 설정을 통해 커스텀 Alert가 VoiceOver에서 어떻게 읽히게 할 것인지에 관한 제어 (도입 여부 고민?)
        //        view.isAccessibilityElement = false
        //        containerView.isAccessibilityElement = true
        //        containerView.accessibilityTraits = [.staticText]
        //        containerView.accessibilityLabel = [titleText, messageText].compactMap { $0 }.joined(separator: ", ")
    }
    
    private func setupHierarchy() {
        view.addSubviews(dimView, containerView)
        
        containerView.addSubviews(warningImageView,
                                  titleLabel,
                                  messageLabel,
                                  buttonStackView)
    }
    
    private func setupLayout() {
        dimView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        containerView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalToSuperview().inset(40)
        }
        
        warningImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(40)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(warningImageView.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
            $0.horizontalEdges.lessThanOrEqualToSuperview().inset(20)
        }
        
        messageLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
            $0.horizontalEdges.lessThanOrEqualToSuperview().inset(40)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(messageLabel.snp.bottom).offset(20)
            $0.height.equalTo(52)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
}
    
@objc private extension AlertViewController {
    
    //MARK: - @objc Method
    
    func dimViewTapped() {
        animateOut { [weak self] in
            self?.dismiss(animated: false)
        }
    }
}

private extension AlertViewController {
    
    //MARK: - Private Method

    private func setupTarget() {
        dimView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dimViewTapped)))
    }

    private func setupButtons() {
        actions.forEach { action in
            let button = UIButton()
            button.setTitle(action.buttonTitle, for: .normal)
            button.titleLabel?.setTextStyle(.bodySemi14)

            switch action.style {
            case .primaryRight:
                button.backgroundColor = .gray600
                button.setTitleColor(.white, for: .normal)
            case .secondaryLeft:
                button.backgroundColor = .gray100
                button.setTitleColor(.gray400, for: .normal)
            }

            button.addAction(UIAction { [weak self] _ in
                self?.animateOut {
                    action.onTap()
                    self?.dismiss(animated: false)
                }
            }, for: .touchUpInside)

            buttonStackView.addArrangedSubview(button)
        }
    }

    // MARK: - Animation
    
    private func animateIn() {
        UIView.animate(withDuration: 0.22, delay: 0, options: [.curveEaseOut, .allowUserInteraction]) {
            self.dimView.alpha = 1
            self.containerView.alpha = 1
            self.containerView.transform = .identity
        }
    }

    private func animateOut(_ completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.18, delay: 0, options: [.curveEaseIn, .allowUserInteraction]) {
            self.dimView.alpha = 0
            self.containerView.alpha = 0
            self.containerView.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
        } completion: { _ in
            self.onDismiss?()
            completion()
        }
    }
}
