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
    
    // MARK: - Constraints
    
    private var titleWidthConstraint: Constraint?
    private var artistWidthConstraint: Constraint?

    // MARK: - UI Properties
    
    private let containerView = UIView()
    private let coverImageView = UIImageView()
    private let editorBadgeImageView = UIImageView(image: IconLiterals.ic_editor_20)
    private let musicTitleLabel = UILabel()
    private let artistNameLabel = UILabel()
    private let spacerView = UIView()
    private let labelStackView = UIStackView()
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
        updateLabelWidthsIfNeeded()
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
            $0.numberOfLines = 1
            $0.lineBreakMode = .byTruncatingTail
         }
        
        labelStackView.do {
            $0.axis = .horizontal
            $0.alignment = .center
            $0.distribution = .fill
            $0.spacing = 0
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
            labelStackView,
            commentLabel
        )
        
        labelStackView.addArrangedSubviews(
            musicTitleLabel,
            artistNameLabel,
            spacerView
        )
        
        labelStackView.setCustomSpacing(6, after: musicTitleLabel)
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
        
        labelStackView.snp.makeConstraints {
            $0.bottom.equalTo(commentLabel.snp.top).offset(-4)
            $0.leading.equalTo(coverImageView.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().inset(12)
        }
        
        musicTitleLabel.snp.makeConstraints {
            titleWidthConstraint = $0.width.equalTo(0).constraint
        }
        artistNameLabel.snp.makeConstraints {
            artistWidthConstraint = $0.width.equalTo(0).constraint
        }
        
        titleWidthConstraint?.deactivate()
        artistWidthConstraint?.deactivate()
        
        commentLabel.snp.makeConstraints {
            $0.top.equalTo(musicTitleLabel.snp.bottom).offset(4)
            $0.leading.equalTo(coverImageView.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().inset(12)
            $0.bottom.equalTo(coverImageView)
        }
    }
}

private extension QuestionPostCell {
    
    //MARK: - Private Method
    
    func updateLabelWidthsIfNeeded() {
        //stackView가 실제 너비를 가진 이후에 계산
        let stackWidth = labelStackView.bounds.width
        guard stackWidth > 0 else { return }

        //라벨이 차지할 수 있는 총 폭 (title-artist 사이 spacing 제외)
        let available = stackWidth - 6
        guard available > 0 else { return }

        //각 라벨의 보정 전 너비
        let titleWidth = ceil(musicTitleLabel.intrinsicContentSize.width)
        let artistWidth = ceil(artistNameLabel.intrinsicContentSize.width)

        let total = titleWidth + artistWidth
        let half = floor(available / 2.0)

        //합이 전체를 안 넘으면 제약 없이, 남는 공간은 spacer
        if total <= available {
            titleWidthConstraint?.deactivate()
            artistWidthConstraint?.deactivate()
            return
        }

        //합이 전체를 넘고 title만 half 초과 artist는 half 이하
        if titleWidth > half && artistWidth <= half {
            let fixedArtist = min(artistWidth, available)
            let fixedTitle = max(0, available - fixedArtist)

            applyFixedWidths(title: fixedTitle, artist: fixedArtist)
            return
        }

        //합이 전체를 넘고 artist만 half 초과, title은 half 이하
        if artistWidth > half && titleWidth <= half {
            let fixedTitle = min(titleWidth, available)
            let fixedArtist = max(0, available - fixedTitle)

            applyFixedWidths(title: fixedTitle, artist: fixedArtist)
            return
        }

        //둘 다 half 초과 → 5:5
        applyFixedWidths(title: half, artist: half)
    }

    func applyFixedWidths(title: CGFloat, artist: CGFloat) {
        titleWidthConstraint?.activate()
        artistWidthConstraint?.activate()

        //보정된 width 업데이트
        titleWidthConstraint?.update(offset: title)
        artistWidthConstraint?.update(offset: artist)
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
