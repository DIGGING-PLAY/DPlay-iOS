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
    static let identifier = "SongSearchCell"
    
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
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 6
            $0.backgroundColor = .gray200
        }
        
        titleLabel.do {
            $0.font = .systemFont(ofSize: 16, weight: .semibold)
            $0.textColor = .black
        }
        
        artistLabel.do {
            $0.font = .systemFont(ofSize: 14, weight: .regular)
            $0.textColor = .gray600
        }
        
        checkmarkImageView.do {
            $0.image = IconLiterals.ic_check_circle_24
            $0.tintColor = .dplay_pink
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
            $0.size.equalTo(44)
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(coverImageView.snp.trailing).offset(12)
            $0.trailing.lessThanOrEqualTo(checkmarkImageView.snp.leading).offset(-12)
            $0.top.equalToSuperview().inset(10)
        }
        
        artistLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel)
            $0.trailing.lessThanOrEqualTo(checkmarkImageView.snp.leading).offset(-12)
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.bottom.equalToSuperview().inset(10)
        }
        
        checkmarkImageView.snp.makeConstraints {
            $0.size.equalTo(24)
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
    }
}

extension SongSearchCell {
    
    // MARK: - Configure
    func configure(item: MusicAddResponseDTO, isSelected: Bool) {
        titleLabel.text = item.songTitle
        artistLabel.text = item.artistName
        
        if let url = URL(string: item.coverImg) {
            coverImageView.kf.setImage(with: url)
        }
        
        checkmarkImageView.isHidden = !isSelected
    }
}
