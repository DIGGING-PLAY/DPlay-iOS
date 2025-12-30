//
//  SettingItemButton.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 12/10/25.
//

import UIKit

import SnapKit
import Then

enum SettingsItem: CaseIterable {
    case notice
    case inquiry
    case termsOfService
    case privacyPolicy

    var title: String {
        switch self {
        case .notice:
            return "공지사항"
        case .inquiry:
            return "문의/제안하기"
        case .termsOfService:
            return "서비스 이용 약관"
        case .privacyPolicy:
            return "개인정보 처리방침"
        }
    }
    
    var redirectURL: URL? {
        switch self {
        case .notice:
            return URL(string: "https://www.notion.so/2d13aeb558c980919796c2b4d7109369?source=copy_link")
        case .inquiry:
            return URL(string: "https://forms.gle/reQb2nmhjSqXVvnq7")
        case .termsOfService:
            return URL(string: "https://www.notion.so/2d13aeb558c9801fb8c2db2ae6ac2c3e?source=copy_link")
        case .privacyPolicy:
            return URL(string: "https://www.notion.so/2d13aeb558c98003b480f83b06245430?source=copy_link")
        }
    }
}

final class SettingItemButton: UIButton {
    
    //MARK: - Properties
    
    let itemType: SettingsItem
        
    //MARK: - UI Properties

    private let buttonTitleLabel = UILabel()
    private let arrowImageView = UIImageView(image: IconLiterals.ic_arrow_right_16)
    
    //MARK: - Init
    
    init(itemType: SettingsItem) {
        self.itemType = itemType

        super.init(frame: .zero)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension SettingItemButton {
    
    //MARK: - setup
    
    func setupStyle() {
        buttonTitleLabel.do {
            $0.text = itemType.title
            $0.setTextStyle(.bodySemi16)
            $0.textColor = .gray600
        }
    }
    
    func setupHierarchy() {
        addSubviews(buttonTitleLabel, arrowImageView)
    }
    
    func setupLayout() {
        buttonTitleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
        }
        
        arrowImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16)
        }
    }
}
