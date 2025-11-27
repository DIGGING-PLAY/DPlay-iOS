//
//  RecommendationPopupView.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 11/27/25.
//

import UIKit

import SnapKit
import Then

final class RecommendationPopupView: UIView {

    // MARK: - UI Properties

    private let dimView = UIView()
    private let containerView = UIView()

    private let closeButton = UIButton(type: .custom)
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let actionButton = UIButton(type: .custom)

    // MARK: - Callbacks
    
    private var actionHandler: (() -> Void)?
    private var closeHandler: (() -> Void)?

    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
        setupHierarchy()
        setupLayout()
    }

    required init?(coder: NSCoder) { fatalError() }
}

private extension RecommendationPopupView {

    // MARK: - Layout
    
    func setupStyle() {

        dimView.do {
            $0.backgroundColor = UIColor.black.withAlphaComponent(0.80)
        }

        containerView.do {
            $0.backgroundColor = .white
            $0.roundCorners(cornerRadius: 12)
        }

        closeButton.do {
            $0.setImage(IconLiterals.ic_close_24, for: .normal)
            $0.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        }

        iconImageView.do {
            $0.image = ImageLiterals.img_key
            $0.contentMode = .scaleAspectFit
        }

        titleLabel.do {
            $0.text = "더 많은 추천을 만나고 싶나요?"
            $0.textColor = .black
            $0.setTextStyle(.bodyBold16)
            $0.textAlignment = .center
            $0.numberOfLines = 0
        }

        subtitleLabel.do {
            $0.text = "오늘의 추천곡을 작성하면 볼 수 있어요!"
            $0.textColor = .gray400
            $0.setTextStyle(.bodyMedi14)
            $0.textAlignment = .center
        }

        actionButton.do {
            $0.setTitle("곡 추천하러가기", for: .normal)
            $0.backgroundColor = .gray600
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.setTextStyle(.bodySemi16)
            $0.addTarget(self, action: #selector(didTapAction), for: .touchUpInside)
        }
    }

    func setupHierarchy() {
        addSubviews(dimView, containerView)
        
        containerView.addSubviews(
            closeButton,
            iconImageView,
            titleLabel,
            subtitleLabel,
            actionButton
        )
    }

    func setupLayout() {

        dimView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        containerView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(295)
            $0.height.equalTo(225)
        }

        closeButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(12)
            $0.size.equalTo(32)
        }

        iconImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(80)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(iconImageView.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(12)
        }

        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.horizontalEdges.equalToSuperview().inset(12)
        }

        actionButton.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(52)
            $0.bottom.equalToSuperview()
        }
    }
}

private extension RecommendationPopupView {

    @objc func didTapAction() {
        actionHandler?()
    }

    @objc func didTapClose() {
        closeHandler?()
    }
}

extension RecommendationPopupView {

    func configure(
        action: (() -> Void)? = nil,
        close: (() -> Void)? = nil
    ) {
        // 화면 이동 로직 필요함
        self.actionHandler = action
        self.closeHandler = close
    }
}
