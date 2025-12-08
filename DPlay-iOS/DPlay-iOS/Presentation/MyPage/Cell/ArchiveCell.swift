//
//  ArchiveCell.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 11/27/25.
//

import UIKit

import Kingfisher
import SnapKit
import Then

final class ArchiveCell: UICollectionViewCell {
        
    // MARK: - UI Properties
    
    private let imageView = UIImageView()
    private let circleView = UIView()
    private let musicTitleLabel = UILabel()
    private let artistNameLabel = UILabel()
    
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
    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        
//        imageView.image = nil
//        musicTitleLabel.text = ""
//        artistNameLabel.text = ""
//    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.roundCorners(cornerRadius: imageView.frame.width / 2)
        circleView.roundCorners(cornerRadius: imageView.frame.width / 16)
    }
}

private extension ArchiveCell {
    func setupStyle() {
        backgroundColor = .clear
        
        imageView.do {
            $0.backgroundColor = .gray600
            $0.contentMode = .scaleAspectFill
            $0.roundCorners(cornerRadius: frame.width / 2)
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.gray200.cgColor
        }
        
        circleView.do {
            $0.backgroundColor = .white
            $0.contentMode = .scaleAspectFill
            $0.roundCorners(cornerRadius: frame.width / 16)
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.gray200.cgColor
        }
        
        musicTitleLabel.do {
            $0.text = " "
            $0.textColor = .dplay_black
            $0.setTextStyle(.bodySemi14)
            $0.numberOfLines = 1
            $0.lineBreakMode = .byTruncatingTail
        }
        
        artistNameLabel.do {
            $0.text = " "
            $0.textColor = .gray400
            $0.setTextStyle(.capMedi12)
            $0.numberOfLines = 1
            $0.lineBreakMode = .byTruncatingTail
        }
    }

    
    func setupHierarchy() {
        addSubviews(
            imageView,
            circleView,
            musicTitleLabel,
            artistNameLabel
        )
    }
    
    func setupLayout() {
        imageView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(imageView.snp.width)
        }
        
        circleView.snp.makeConstraints {
            $0.center.equalTo(imageView.snp.center)
            $0.size.equalTo(imageView.snp.width).dividedBy(8)
        }
        
        musicTitleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(5)
            $0.centerX.equalToSuperview()
        }
        
        artistNameLabel.snp.makeConstraints {
            $0.top.equalTo(musicTitleLabel.snp.bottom).offset(1)
            $0.centerX.bottom.equalToSuperview()
        }
    }
}

extension ArchiveCell {
    func configureCell(with model: MyPageTrackPost) {
        guard let url = URL(string: model.track.coverImage) else { return }
        
        imageView.kf.setImage(with: url)
        musicTitleLabel.text = model.track.title
        artistNameLabel.text = model.track.artist
    }
}
