//
//  SongSearchCell.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 11/24/25.
//

import UIKit

import SnapKit
import Then
import Kingfisher

final class SongSearchCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identifier = SongSearchCell.className
    
    // MARK: - UI Properties
    
    private let coverImageView = UIImageView()
    private let titleLabel = UILabel()
    private let artistLabel = UILabel()
    private let checkmarkImageView = UIImageView()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) { fatalError() }
}

private extension SongSearchCell {
    
    // MARK: - Layout
    
    func setupStyle() {
        backgroundColor = .white
        selectionStyle = .none
        
        coverImageView.do {
            $0.contentMode = .scaleAspectFill
            $0.roundCorners(cornerRadius: 16)
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.gray200.cgColor
            $0.backgroundColor = .white
        }
        
        titleLabel.do {
            $0.setTextStyle(.bodySemi16)
            $0.textColor = .dplay_black
        }
        
        artistLabel.do {
            $0.setTextStyle(.bodyMedi14)
            $0.textColor = .gray400
        }
        
        checkmarkImageView.do {
            $0.image = IconLiterals.ic_check_circle_24
            $0.isHidden = true
        }
    }
    
    func setupHierarchy() {
        contentView.addSubviews(
            coverImageView,
            titleLabel,
            artistLabel,
            checkmarkImageView
        )
    }
    
    func setupLayout() {
        coverImageView.snp.makeConstraints {
            $0.size.equalTo(52)
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(coverImageView.snp.trailing).offset(12)
            $0.trailing.lessThanOrEqualTo(checkmarkImageView.snp.leading).offset(-12) // 글자가 길어질 경우 checkmarkImageView 보다 12 정도 떨어 지도록 구현
            $0.top.equalToSuperview().inset(12)
        }
        
        artistLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel)
            $0.trailing.lessThanOrEqualTo(checkmarkImageView.snp.leading).offset(-12)
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.bottom.equalToSuperview().inset(15.5)
        }
        
        checkmarkImageView.snp.makeConstraints {
            $0.size.equalTo(24)
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
    }
}

extension SongSearchCell {

    // MARK: - Configure

    func configure(item: MusicTrack, isSelected: Bool) {
        titleLabel.text = item.title
        artistLabel.text = item.artist

        coverImageView.setImage(url: item.coverURL)
        checkmarkImageView.isHidden = !isSelected
        backgroundColor = isSelected ? .gray200 : .white
    }
}
