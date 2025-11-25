//
//  OnboardingImageCell.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 11/26/25.
//

import UIKit

import SnapKit

final class OnboardingImageCell: UICollectionViewCell {
        
    // MARK: - UI Properties
    
    private let imageView = UIImageView()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension OnboardingImageCell {
    func setupHierarchy() {
        addSubview(imageView)
    }
    
    func setupLayout() {
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension OnboardingImageCell {
    func configure(with image: UIImage) {
        imageView.image = image
    }
}
