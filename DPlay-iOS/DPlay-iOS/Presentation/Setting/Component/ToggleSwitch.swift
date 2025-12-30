//
//  ToggleSwitch.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 12/10/25.
//

import UIKit

import SnapKit
import Then

final class ToggleSwitch: UIControl {
    
    //MARK: - Properties

    private(set) var isOn: Bool = false
    var onColor: UIColor = .dplay_pink { didSet { updateUI(animated: false) } }
    var offColor: UIColor = .gray300 { didSet { updateUI(animated: false) } }
    var circleColor: UIColor = .white { didSet { circleView.backgroundColor = circleColor } }
    
    //MARK: - Constraints
    
    private var circleLeadingConstraint: Constraint?
    private var circleTrailingConstraint: Constraint?

    //MARK: - UI Properties

    private let backgroundView = UIView()
    private let circleView = UIView()
    
    //MARK: - Init
    
    init() {
        super.init(frame: .zero)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupGesture()
        updateUI(animated: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        backgroundView.roundCorners(cornerRadius: backgroundView.bounds.height / 2)
        circleView.roundCorners(cornerRadius: circleView.bounds.height / 2)
    }

}

@objc private extension ToggleSwitch {

    //MARK: - @objc Method
    
    func didTap() {
        guard isEnabled else { return }
        setOn(!isOn, animated: true)
    }
}

private extension ToggleSwitch {
    
    //MARK: - Layout
    
    func setupStyle() {
        backgroundColor = .clear

        backgroundView.do {
            $0.backgroundColor = offColor
            $0.isUserInteractionEnabled = false
        }
        
        circleView.do {
            $0.backgroundColor = circleColor
            $0.isUserInteractionEnabled = false
        }
    }

    func setupHierarchy() {
        addSubviews(backgroundView, circleView)
    }

    func setupLayout() {
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        circleView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)

            circleLeadingConstraint = $0.leading.equalToSuperview().inset(2).constraint
            circleTrailingConstraint = $0.trailing.equalToSuperview().inset(2).constraint
        }
    }

    func setupGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
        addGestureRecognizer(tap)
    }
    
    func updateUI(animated: Bool) {
        let backgroundColor = isOn ? onColor : offColor

        // isOn에 따른 제약 활성화 상태 변경
        if isOn {
            circleLeadingConstraint?.deactivate()
            circleTrailingConstraint?.activate()
        } else {
            circleTrailingConstraint?.deactivate()
            circleLeadingConstraint?.activate()
        }

        let animations = {
            self.backgroundView.backgroundColor = backgroundColor
            self.alpha = self.isEnabled ? 1.0 : 0.5
            self.layoutIfNeeded()
        }

        if animated {
            UIView.animate(
                withDuration: 0.25,
                delay: 0,
                options: [.curveEaseInOut, .allowUserInteraction],
                animations: animations
            )
        } else {
            animations()
        }
    }
}

extension ToggleSwitch {
    
    //MARK: - Method
    
    func setOn(_ on: Bool, animated: Bool) {
        guard isOn != on else { return }
        isOn = on
        updateUI(animated: animated)
        sendActions(for: .valueChanged)
    }
}
