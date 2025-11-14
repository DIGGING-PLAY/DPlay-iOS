//
//  MusicAlbumCell.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 11/14/25.
//

import UIKit

import SnapKit
import Then

class MusicAlbumCell: UICollectionViewCell {
    
    // MARK: - Properties
    static let identifier = "EditorCardCell"
    
    // MARK: - UI Properties
    private let musicAlbumCoverImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 256 / 2
        $0.clipsToBounds = true
        $0.image = ImageLiterals.img_card_cover
    }
    
    private let musicScrapButton = UIButton().then {
        $0.setImage(IconLiterals.ic_bookmark_24, for: .normal)
        $0.backgroundColor = .black
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
    }
    
    private let cardBackgroundView = UIView().then {
        $0.backgroundColor = UIColor.dplay_pink.withAlphaComponent(0.5)
        $0.layer.cornerRadius = 12
        $0.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner] // ✨ 하단만 둥글게
        $0.clipsToBounds = true
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.dplay_pink.cgColor
    }
    
    // 블러 레이어
    private let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .light)).then {
        $0.alpha = 0.9  // 블러 강도
    }

    // 반투명 핑크 오버레이
    private let overlayView = UIView().then {
        $0.backgroundColor = UIColor.dplay_pink.withAlphaComponent(0.25)
    }
    
    private let userProfileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 12 / 2
        $0.clipsToBounds = true
        $0.image = ImageLiterals.img_mock_profile
    }
    
    private let userNameLabel = UILabel().then {
        $0.text = "윤서얌"
        $0.font = .dplayFont(.bodyBold16)
        $0.textColor = .white
    }
    
    private let userCommentQuoteUpIamgeView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = IconLiterals.ic_quote_up
    }
    
    private let userCommentQuoteDownIamgeView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = IconLiterals.ic_quote_down
    }
    
    private let userCommentLabel = UILabel().then {
        $0.text = "진짜 나오자마자 들었는데 이 노래가 최고! 출근곡, 퇴근곡, 노동곡 다 되는 짱제토! 일하는 매장에서 수십 번씩 들…"
        $0.font = .dplayFont(.bodySemi14)
        $0.textColor = .white
        $0.numberOfLines = 3
    }
    
    private let userHeartButton = UIButton().then {
        $0.setImage(IconLiterals.ic_heart_w, for: .normal)
        $0.tintColor = .white
    }
    
    private let heartCountLabel = UILabel().then {
        $0.text = "24"
        $0.font = .dplayFont(.bodySemi14)
        $0.textColor = .white
    }
    
    private let musicStreamingButton = UIButton().then {
        $0.setImage(IconLiterals.ic_stream, for: .normal)
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 16
        $0.layer.masksToBounds = true
    }
    
    // MARK: - Init
    
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

private extension MusicAlbumCell {
    
    func setupStyle() {
        backgroundColor = .clear
    }
    
    func setupHierarchy() {
        contentView.addSubview(musicAlbumCoverImageView)
        contentView.addSubview(cardBackgroundView)
        contentView.addSubview(musicScrapButton)
        
        cardBackgroundView.addSubview(blurView)
        cardBackgroundView.addSubview(overlayView)
        
        cardBackgroundView.addSubviews(
            userProfileImageView,
            userNameLabel,
            userCommentQuoteUpIamgeView,
            userCommentQuoteDownIamgeView,
            userCommentLabel,
            userHeartButton,
            heartCountLabel,
            musicStreamingButton
        )
    }
    
    func setupLayout() {
        
        musicAlbumCoverImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
            $0.size.equalTo(256)
        }
        
        cardBackgroundView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(204)
        }
        blurView.snp.makeConstraints { $0.edges.equalToSuperview() }
        overlayView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        userProfileImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.leading.equalToSuperview().inset(12)
            $0.size.equalTo(28)
        }
        
        userNameLabel.snp.makeConstraints {
            $0.centerY.equalTo(userProfileImageView)
            $0.leading.equalTo(userProfileImageView.snp.trailing).offset(6)
        }
        
        
        userCommentQuoteUpIamgeView.snp.makeConstraints {
            $0.top.equalTo(userProfileImageView.snp.bottom).offset(24)
            $0.leading.equalToSuperview().inset(12)
            $0.size.equalTo(16)
        }
        
        userCommentLabel.snp.makeConstraints {
            $0.top.equalTo(userCommentQuoteUpIamgeView.snp.top)
            $0.leading.equalTo(userCommentQuoteUpIamgeView.snp.trailing).offset(4)
            $0.trailing.equalTo(userCommentQuoteDownIamgeView.snp.leading).inset(4)
        }
        
    
        userCommentQuoteDownIamgeView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(12)
            $0.bottom.equalTo(userCommentLabel.snp.bottom)
            $0.size.equalTo(16)
        }
        
        userHeartButton.snp.makeConstraints {
            $0.top.equalTo(userNameLabel.snp.bottom).offset(44)
            $0.leading.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview().inset(12)
            $0.size.equalTo(24)
        }
        
        heartCountLabel.snp.makeConstraints {
            $0.centerY.equalTo(userHeartButton)
            $0.leading.equalTo(userHeartButton.snp.trailing).offset(2)
        }
        
        musicStreamingButton.snp.makeConstraints {
            $0.top.equalTo(userNameLabel.snp.bottom).offset(24)
            $0.trailing.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview().inset(12)
            $0.size.equalTo(44)
        }
    }
}
