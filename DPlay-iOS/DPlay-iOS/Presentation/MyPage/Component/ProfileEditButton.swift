//
//  ProfileEditButton.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 11/17/25.
//

import UIKit

import Kingfisher
import SnapKit
import Then

final class ProfileEditButton: UIButton {
        
    //MARK: - UI Properties

    private let profileImageView = UIImageView(image: ImageLiterals.img_profile)
    private let editImageView = UIImageView(image: IconLiterals.ic_circle_edit)
    
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

private extension ProfileEditButton {
    
    //MARK: - setup
    
    func setupStyle() {
        profileImageView.do {
            $0.roundCorners(cornerRadius: 40)
            $0.contentMode = .scaleAspectFill
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.gray200.cgColor
        }
    }
    
    func setupHierarchy() {
        addSubviews(profileImageView, editImageView)
    }
    
    func setupLayout() {
        profileImageView.snp.makeConstraints {
            $0.size.equalTo(80)
            $0.center.equalToSuperview()
        }
        
        editImageView.snp.makeConstraints {
            $0.trailing.bottom.equalToSuperview()
        }
    }
}

extension ProfileEditButton {
    
    //MARK: - setter
    
    func setProfileButton(isHost: Bool, profileImageUrl: String) {
        editImageView.isHidden = !isHost
        isEnabled = isHost
        
        if let url = URL(string: profileImageUrl) {
            profileImageView.kf.setImage(with: url)
        } else {
            profileImageView.image = ImageLiterals.img_profile
        }
    }
    
    //MARK: - getter
    
    func getProfileUIImage() -> UIImage {
        return profileImageView.image ?? UIImage()
    }
}
