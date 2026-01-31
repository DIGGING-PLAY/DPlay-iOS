//
//  ReportSheetView.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 11/27/25.
//

import UIKit

import SnapKit
import Then

enum ReportReason: String, CaseIterable {
    case inappropriate = "부적절한 내용을 포함하고 있어요."
    case offensive = "불쾌한 표현이 포함되어 있어요."
    case spam = "의심스럽거나 스팸이에요."
    case copyright = "저작권을 침해하고 있어요."
}

final class ReportSheetView: UIView {

    // MARK: - UI Properties

    let dimView = UIView()
    let containerView = UIView()
    private let titleLabel = UILabel()
    private let closeButton = UIButton()
    private let stackView = UIStackView()
    private let confirmButton = UIButton()

    // MARK: - Properties
    
    private var selectedReason: ReportReason?
    private var optionButtons: [UIButton] = []

    /// 선택된 사유를 VC로 전달
    var confirmHandler: ((ReportReason) -> Void)?
    var closeHandler: (() -> Void)?

    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupReasonButtons()
    }

    required init?(coder: NSCoder) { fatalError() }
}

private extension ReportSheetView {

    // MARK: - Setup

    func setupStyle() {

        dimView.do {
            $0.backgroundColor = UIColor.black.withAlphaComponent(0.8)
            $0.alpha = 0
            $0.addGestureRecognizer(
                UITapGestureRecognizer(target: self, action: #selector(didTapDim))
            )
        }

        containerView.do {
            $0.backgroundColor = .white
            $0.roundCorners(cornerRadius: 16)
            $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
        
        titleLabel.do {
            $0.text = "신고 사유를 선택해주세요"
            $0.setTextStyle(.titleBold18)
            $0.textColor = .dplay_black
        }

        closeButton.do {
            $0.setImage(IconLiterals.ic_close_24, for: .normal)
            $0.tintColor = .dplay_black
            $0.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        }

        stackView.do {
            $0.axis = .vertical
            $0.spacing = 0
        }

        confirmButton.do {
            $0.setTitle("신고하기", for: .normal)
            $0.titleLabel?.setTextStyle(.bodyBold16)
            $0.backgroundColor = .gray200
            $0.setTitleColor(.gray400, for: .normal)
            $0.roundCorners(cornerRadius: 12)
            $0.isEnabled = false
            $0.addTarget(self, action: #selector(didTapConfirm), for: .touchUpInside)
        }
    }

    func setupHierarchy() {
        addSubviews(dimView, containerView)

        containerView.addSubviews(
            titleLabel,
            closeButton,
            stackView,
            confirmButton
        )
    }

    func setupLayout() {

        dimView.snp.makeConstraints { $0.edges.equalToSuperview() }

        containerView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(355)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(28.5)
            $0.leading.equalToSuperview().inset(16)
        }

        closeButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(28.5)
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview().inset(16)
            $0.size.equalTo(32)
        }

        stackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16.5)
            $0.horizontalEdges.equalToSuperview()
        }

        confirmButton.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(16)
            $0.height.equalTo(53)
        }
    }
}

@objc private extension ReportSheetView {
    
    //MARK: - @objc Method
    
    @objc func didTapDim() {
        closeHandler?()
    }

    @objc func didTapClose() {
        closeHandler?()
    }

    @objc func didTapConfirm() {
        guard let selectedReason else { return }
        confirmHandler?(selectedReason)
    }

    /// 선택값을 기록하고 버튼 전체를 다시 그리는 메서드
    @objc func didTapReason(_ sender: UIButton) {
        selectedReason = ReportReason.allCases[sender.tag]
        refreshButtons()
        updateConfirmButton()
    }
}

private extension ReportSheetView {

    // MARK: - UI Update
    
    /// 신고 case별 버튼 삽입
    func setupReasonButtons() {
        ReportReason.allCases.enumerated().forEach { idx, reason in
            
            var config = UIButton.Configuration.plain()
            config.title = reason.rawValue
            config.baseForegroundColor = .gray500
            config.contentInsets = .init(top: 12, leading: 16, bottom: 12, trailing: 16)
            
            // 폰트 적용
            config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                var new = incoming
                new.font = .dplayFont(.bodySemi14)
                return new
            }
            
            let button = UIButton(configuration: config)
            button.tag = idx
            button.contentHorizontalAlignment = .leading
            
            // 클릭 이벤트만 연결
            button.addTarget(self, action: #selector(didTapReason(_:)), for: .touchUpInside)
            
            optionButtons.append(button)
            stackView.addArrangedSubview(button)
        }
    }
    
    /// 선택 신고 버튼 UI 업데이트 메서드
    func refreshButtons() {
        for button in optionButtons {
            let isSelected = button.tag == selectedReasonIndex()
            
            var config = button.configuration
            config?.image = isSelected ? IconLiterals.ic_check_circle_20 : nil
            config?.imagePadding = 10
            button.configuration = config
            button.backgroundColor = isSelected ? .gray100 : .white
        }
    }
    
    /// 신고하기 버튼 활성화는 여기서만 담당
    func updateConfirmButton() {
        let enabled = (selectedReason != nil)
        confirmButton.isEnabled = enabled
        confirmButton.backgroundColor = enabled ? .gray600 : .gray200
        confirmButton.setTitleColor(enabled ? .white : .gray400, for: .normal)
    }

    func selectedReasonIndex() -> Int? {
        guard let selectedReason else { return nil }
        return ReportReason.allCases.firstIndex(of: selectedReason)
    }
}

extension ReportSheetView {

    func present() {
        layoutIfNeeded()

        // 초기 위치: 아래로 숨기기
        containerView.transform = CGAffineTransform(translationX: 0, y: containerView.frame.height)
        UIView.animate(withDuration: 0.25) {
            self.dimView.alpha = 1
            self.containerView.transform = .identity // 제자리로 위치
        }
    }

    func dismiss(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.25, animations: {
            self.dimView.alpha = 0
            self.containerView.transform = CGAffineTransform(translationX: 0, y: self.containerView.frame.height)
        }) { _ in
            completion?()
            self.removeFromSuperview()
        }
    }
}
