//
//  RegisteredMusicCell.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 11/27/25.
//

import UIKit

import Kingfisher
import SnapKit
import Then

final class RegisteredMusicCell: UICollectionViewCell {
        
    // MARK: - UI Properties
    
    private let imageView = UIImageView()
    private let moreButton = UIButton()
    private let musicTitleLabel = UILabel()
    private let artistNameLabel = UILabel()
    private let commentLabel = UILabel()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}

private extension RegisteredMusicCell {
    func setupStyle() {
        backgroundColor = .white
        roundCorners(cornerRadius: 20)
        layer.borderWidth = 1
        layer.borderColor = UIColor.gray200.cgColor
        
        imageView.do {
            $0.backgroundColor = .gray600
            $0.roundCorners(cornerRadius: 16)
            $0.contentMode = .scaleAspectFill
        }
        
        moreButton.do {
            $0.setImage(IconLiterals.ic_more_g_20, for: .normal)
        }
        
        musicTitleLabel.do {
            $0.text = " "
            $0.textColor = .dplay_black
            $0.setTextStyle(.bodyBold16)
            $0.numberOfLines = 1
            $0.lineBreakMode = .byTruncatingTail
        }
        
        artistNameLabel.do {
            $0.text = " "
            $0.textColor = .gray400
            $0.setTextStyle(.capMedi12)
         }
        
        commentLabel.do {
            $0.text = " "
            $0.textColor = .gray500
            $0.setTextStyle(.capMedi12)
            $0.numberOfLines = 1
            $0.lineBreakMode = .byTruncatingTail
        }
    }
    
    func setupHierarchy() {
        addSubviews(
            imageView,
            moreButton,
            musicTitleLabel,
            artistNameLabel,
            commentLabel
        )
    }
    
    func setupLayout() {
        musicTitleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        artistNameLabel.setContentCompressionResistancePriority(.required, for: .horizontal)

        imageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(12)
            $0.size.equalTo(68)
        }
        
        moreButton.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.top).offset(7)
            $0.trailing.equalToSuperview().inset(12)
            $0.size.equalTo(20)
        }
        
        musicTitleLabel.snp.makeConstraints {
            $0.top.equalTo(moreButton.snp.bottom)
            $0.leading.equalTo(imageView.snp.trailing).offset(8)
        }
        
        artistNameLabel.snp.makeConstraints {
            $0.centerY.equalTo(musicTitleLabel.snp.centerY)
            $0.leading.equalTo(musicTitleLabel.snp.trailing).offset(6)
            $0.trailing.lessThanOrEqualToSuperview().inset(12)
        }
        
        commentLabel.snp.makeConstraints {
            $0.top.equalTo(musicTitleLabel.snp.bottom).offset(4)
            $0.leading.equalTo(imageView.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().inset(12)
        }
    }
}

extension RegisteredMusicCell {
    func configureCell(with model: MyPageTrackPost) {
        guard let url = URL(string: model.track.coverImage) else { return }
        
        imageView.kf.setImage(with: url)
        musicTitleLabel.text = model.track.title
        artistNameLabel.text = model.track.artist
        commentLabel.text = model.content
    }
}
