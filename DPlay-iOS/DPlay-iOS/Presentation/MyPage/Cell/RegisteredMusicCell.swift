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
    
    // MARK: - Event Properties

    var onTapMoreButton: (() -> Void)?
    
    // MARK: - Constraints
    
    private var titleWidthConstraint: Constraint?
    private var artistWidthConstraint: Constraint?

    // MARK: - UI Properties
    
    private let imageView = UIImageView()
    private let moreButton = UIButton()
    private let musicTitleLabel = UILabel()
    private let artistNameLabel = UILabel()
    private let spacerView = UIView()
    private let labelStackView = UIStackView()
    private let commentLabel = UILabel()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
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
        updateLabelWidthsIfNeeded()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}

private extension RegisteredMusicCell {
    
    //MARK: - Layout
    
    func setupStyle() {
        backgroundColor = .white
        roundCorners(cornerRadius: 20)
        layer.borderWidth = 1
        layer.borderColor = UIColor.gray200.cgColor
        
        imageView.do {
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
        addSubviews(
            imageView,
            moreButton,
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
        
        labelStackView.snp.makeConstraints {
            $0.top.equalTo(moreButton.snp.bottom)
            $0.leading.equalTo(imageView.snp.trailing).offset(8)
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
            $0.leading.equalTo(imageView.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().inset(12)
        }
    }
}

private extension RegisteredMusicCell {
    
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

@objc private extension RegisteredMusicCell {
    
    //MARK: - @objc Method
    
    func moreButtonTapped() {
        onTapMoreButton?()
    }
}

private extension RegisteredMusicCell {
    
    // MARK: - Private Method
    
    func setupTarget() {
        moreButton.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
    }
}

extension RegisteredMusicCell {
    
    //MARK: - Configure
    
    func configureCell(isHost: Bool, with model: MyPageTrackPost) {
        guard let url = URL(string: model.track.coverImage) else { return }
        
        imageView.kf.setImage(with: url)
        musicTitleLabel.text = model.track.title
        artistNameLabel.text = model.track.artist
        commentLabel.text = model.content
        moreButton.isHidden = !isHost
    }
}
