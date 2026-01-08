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
    private let moreButton = UIButton()
    private let musicTitleLabel = UILabel()
    private let artistNameLabel = UILabel()
    private let commentLabel = UILabel()
    
    // MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        
        setupTarget()
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
        
        moreButton.do {
            $0.setImage(IconLiterals.ic_more_g_20, for: .normal)
        }
        
        musicTitleLabel.do {
            $0.text = "ㅈ ㅣ ㅂ"
            $0.textColor = .dplay_black
            $0.setTextStyle(.bodyBold16)
            $0.numberOfLines = 1
            $0.lineBreakMode = .byTruncatingTail
        }
        
        artistNameLabel.do {
            $0.text = "한로로"
            $0.textColor = .gray400
            $0.setTextStyle(.capMedi12)
         }
        
        commentLabel.do {
            $0.text = "저쪽 집에 불이 어쩌고"
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
            moreButton,
            musicTitleLabel,
            artistNameLabel,
            commentLabel
        )
    }
    
    func setupLayout() {
        musicTitleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        artistNameLabel.setContentCompressionResistancePriority(.required, for: .horizontal)

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
        
        moreButton.snp.makeConstraints {
            $0.top.equalTo(coverImageView.snp.top).offset(7)
            $0.trailing.equalToSuperview().inset(12)
            $0.size.equalTo(20)
        }
        
        musicTitleLabel.snp.makeConstraints {
            $0.top.equalTo(moreButton.snp.bottom)
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
        }
    }
}

@objc private extension QuestionPostCell {
    
    //MARK: - @objc Method
    
    func moreButtonTapped() {
        onTapMoreButton?()
    }
}

private extension QuestionPostCell {
    
    // MARK: - Private Method
    
    func setupTarget() {
        moreButton.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
    }
}

extension QuestionPostCell {
    
    //MARK: - Configure
    
    func configureCell(post: QuestionPostsItemDTO) {
        guard let url = URL(string: post.track.coverImg) else { return }
        
        coverImageView.kf.setImage(with: url)
        musicTitleLabel.text = post.track.songTitle
        artistNameLabel.text = post.track.artistName
        commentLabel.text = post.content
        editorBadgeImageView.isHidden = !post.isEditorPick
    }
}
