//
//  MusicDetailNavigationBar.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 11/16/25.
//

import UIKit

import SnapKit
import Then

final class MusicCommentDetailNavigationBarView: UIView {
    
    // MARK: - Properties
    
    var onTapBack: (() -> Void)?
    var onTapDelete: (() -> Void)?
    var onTapReport: (() -> Void)?

    private var isHost: Bool = false

    // MARK: - UI Properties
    
    private let backButton = UIButton()
    private let dateLabel = UILabel()
    private let menuButton = UIButton()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupTarget()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension MusicCommentDetailNavigationBarView {
    func setupStyle() {
        backgroundColor = .clear
        
        backButton.do {
            $0.setImage(ImageLiterals.img_back, for: .normal)
            $0.contentMode = .scaleAspectFit
            $0.tintColor = .dplay_black
        }
        
        dateLabel.do {
            $0.text = "10월 12일"
            $0.setTextStyle(.titleBold18)
            $0.textColor = .dplay_black
        }
        
        menuButton.do {
            $0.setImage(ImageLiterals.img_dot_menu, for: .normal)
            $0.tintColor = .dplay_black
        }
    }
    
    func setupHierarchy() {
        addSubviews(backButton, dateLabel, menuButton)
    }
    
    func setupLayout() {
        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.size.equalTo(48)
        }
        
        dateLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.equalTo(24)
        }
        
        menuButton.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.size.equalTo(48)
        }
    }
}

@objc private extension MusicCommentDetailNavigationBarView {
    
    //MARK: - @objc Method
    
    func didTapBack() {
        onTapBack?()
    }
    
    func didTapMenu() {
        if isHost {
            onTapDelete?()
        } else {
            onTapReport?()
        }
    }
}

private extension MusicCommentDetailNavigationBarView {
    // MARK: - Private Method
    
    func setupTarget() {
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        menuButton.addTarget(self, action: #selector(didTapMenu), for: .touchUpInside) 
    }
}

extension MusicCommentDetailNavigationBarView {

    // MARK: - Public Configure

    func configure(displayDate: String, isHost: Bool) {
        self.isHost = isHost
        dateLabel.text = Self.format(displayDate)
    }

    // MARK: - Date Formatting

    private static func format(_ date: String) -> String {
        // "2026-01-24" → "1월 24일"
        let components = date.split(separator: "-")
        guard components.count == 3,
              let month = Int(components[1]),
              let day = Int(components[2]) else {
            return date
        }
        return "\(month)월 \(day)일"
    }
}
