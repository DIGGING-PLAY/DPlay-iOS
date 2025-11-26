//
//  ProfileImageSelectButton.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 11/17/25.
//

import UIKit

import SnapKit
import Then

final class ProfileImageSelectButton: UIButton {
        
    //MARK: - UI Properties

    private let profileImageView = UIImageView(image: ImageLiterals.img_profile)
    private let plusImageView = UIImageView(image: IconLiterals.ic_circle_plus)
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ProfileImageSelectButton {
    
    //MARK: - setup
    
    func setupStyle() {
        profileImageView.do {
            $0.roundCorners(cornerRadius: 58)
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.gray200.cgColor
        }
    }
    
    func setupHierarchy() {
        addSubviews(profileImageView, plusImageView)
    }
    
    func setupLayout() {
        profileImageView.snp.makeConstraints {
            $0.size.equalTo(116)
            $0.center.equalToSuperview()
        }
        
        plusImageView.snp.makeConstraints {
            $0.trailing.bottom.equalToSuperview()
        }
    }
}
