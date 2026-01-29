//
//  QuestionPostCell.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 12/31/25.
//

import UIKit

import Kingfisher
import SnapKit
import Then

final class QuestionPostCell: UITableViewCell {
    
    // MARK: - Event Properties

    var onTapMoreButton: (() -> Void)?

    // MARK: - UI Properties
    
    private let containerView = UIView()
    private let coverImageView = UIImageView()
    private let editorBadgeImageView = UIImageView(image: IconLiterals.ic_editor_20)
    private let musicTitleLabel = UILabel()
    private let artistNameLabel = UILabel()
    private let commentLabel = UILabel()
    
    // MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 12, right: 0))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}

private extension QuestionPostCell {
    
    //MARK: - Layout
    
    func setupStyle() {
        backgroundColor = .clear
        selectionStyle = .none

        containerView.do {
            $0.backgroundColor = .white
            $0.roundCorners(cornerRadius: 20)
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.gray200.cgColor
        }
        
        coverImageView.do {
            $0.backgroundColor = .gray
            $0.roundCorners(cornerRadius: 16)
            $0.contentMode = .scaleAspectFill
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
        contentView.addSubviews(
            containerView,
            coverImageView,
            editorBadgeImageView,
            musicTitleLabel,
            artistNameLabel,
            commentLabel
        )
    }
    
    func setupLayout() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        coverImageView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(12)
            $0.leading.equalToSuperview().inset(12)
            $0.height.equalTo(80)
            $0.width.equalTo(68)
        }
        
        editorBadgeImageView.snp.makeConstraints {
            $0.top.equalTo(coverImageView).offset(-4)
            $0.trailing.equalTo(coverImageView).offset(4)
        }
        
        musicTitleLabel.snp.makeConstraints {
            $0.bottom.equalTo(commentLabel.snp.top).offset(-4)
            $0.leading.equalTo(coverImageView.snp.trailing).offset(8)
        }
        
        artistNameLabel.snp.makeConstraints {
            $0.centerY.equalTo(musicTitleLabel.snp.centerY)
            $0.leading.equalTo(musicTitleLabel.snp.trailing).offset(6)
            $0.trailing.lessThanOrEqualToSuperview().inset(12)
        }
        
        commentLabel.snp.makeConstraints {
            $0.top.equalTo(musicTitleLabel.snp.bottom).offset(4)
            $0.leading.equalTo(coverImageView.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().inset(12)
            $0.bottom.equalTo(coverImageView)
        }
    }
}

@objc private extension QuestionPostCell {
    
    //MARK: - @objc Method
    
    func moreButtonTapped() {
        onTapMoreButton?()
    }
}

extension QuestionPostCell {
    
    //MARK: - Configure
    
    func configureCell(post: QuestionPost) {
        guard let url = URL(string: post.track.coverImage) else { return }
        
        coverImageView.kf.setImage(with: url)
        musicTitleLabel.text = post.track.title
        artistNameLabel.text = post.track.artist
        commentLabel.text = post.content
        editorBadgeImageView.isHidden = !post.isEditorPick
    }
}
