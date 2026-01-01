//
//  MusicAlbumCell.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 11/14/25.
//

import UIKit

import SnapKit
import Then

final class MusicAlbumCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = MusicAlbumCell.className

    var onTapPlay: (() -> Void)?
    
    // MARK: - UI Properties
    
    private let musicAlbumCoverImageView = UIImageView()
    private let cardBackgroundView = UIView()
    private let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    private let overlayView = UIView()
    
    private let userProfileImageView = UIImageView()
    private let userNameLabel = UILabel()
    private let userCommentQuoteUpImageView = UIImageView()
    private let userCommentQuoteDownImageView = UIImageView()
    private let userCommentLabel = UILabel()
    private let userHeartButton = UIButton()
    private let heartCountLabel = UILabel()
    private let musicStreamingButton = UIButton()
    
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
}

private extension MusicAlbumCell {
    
    func setupStyle() {
        backgroundColor = .clear
        
        musicAlbumCoverImageView.do {
            $0.contentMode = .scaleAspectFill
            $0.roundCorners(cornerRadius: 128)
            $0.image = ImageLiterals.img_card_cover
        }
                
        cardBackgroundView.do {
            $0.backgroundColor = UIColor.dplay_pink.withAlphaComponent(0.5)
            $0.roundCorners(
                cornerRadius: 12,
                maskedCorners: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            )
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.dplay_pink.cgColor
        }
        
        blurView.alpha = 0.75
        overlayView.backgroundColor = UIColor.dplay_pink.withAlphaComponent(0.25)
        
        userProfileImageView.do {
            $0.contentMode = .scaleAspectFill
            $0.roundCorners(cornerRadius: 6)
            $0.image = ImageLiterals.img_mock_profile
        }
        
        userNameLabel.do {
            $0.text = "윤서얌"
            $0.textColor = .white
            $0.setTextStyle(.bodyBold16)
        }
        
        userCommentQuoteUpImageView.do{
            $0.contentMode = .scaleAspectFit
            $0.image = IconLiterals.ic_quote_up
        }
        
        userCommentQuoteDownImageView.do {
            $0.contentMode = .scaleAspectFit
            $0.image = IconLiterals.ic_quote_down
        }
        
        userCommentLabel.do {
            $0.text = "진짜 나오자마자 들었는데 이 노래가 최고! 출근곡, 퇴근곡, 노동곡 다 되는 짱제토! 일하는 매장에서 수십 번씩 들…"
            $0.textColor = .white
            $0.setTextStyle(.bodySemi14)
            $0.numberOfLines = 3
        }
        
        userHeartButton.do {
            $0.setImage(IconLiterals.ic_heart_w, for: .normal)
            $0.tintColor = .white
        }
        
        heartCountLabel.do {
            $0.text = "24"
            $0.textColor = .white
            $0.setTextStyle(.bodySemi14)
        }
        
        musicStreamingButton.do {
            $0.setImage(IconLiterals.ic_stream_p, for: .normal)
            $0.backgroundColor = .white
            $0.roundCorners(cornerRadius: 16)
        }
    }
    
    func setupHierarchy() {
        contentView.addSubviews(
            musicAlbumCoverImageView,
            cardBackgroundView
        )
        
        cardBackgroundView.addSubviews(
            blurView,
            overlayView
        )
        
        cardBackgroundView.addSubviews(
            userProfileImageView,
            userNameLabel,
            userCommentQuoteUpImageView,
            userCommentQuoteDownImageView,
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
            $0.horizontalEdges.equalToSuperview()
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
        
        userCommentQuoteUpImageView.snp.makeConstraints {
            $0.top.equalTo(userProfileImageView.snp.bottom).offset(24)
            $0.leading.equalToSuperview().inset(12)
            $0.size.equalTo(16)
        }
        
        userCommentLabel.snp.makeConstraints {
            $0.top.equalTo(userCommentQuoteUpImageView.snp.top)
            $0.leading.equalTo(userCommentQuoteUpImageView.snp.trailing).offset(4)
            $0.trailing.equalTo(userCommentQuoteDownImageView.snp.leading).offset(-4)
        }
        
        
        userCommentQuoteDownImageView.snp.makeConstraints {
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

private extension MusicAlbumCell {
    
    // MARK: - Private Method
    private func setupTarget() {
        musicStreamingButton.addTarget(
            self,
            action: #selector(playTapped),
            for: .touchUpInside
        )
    }

    @objc private func playTapped() {
        onTapPlay?()
    }
}

// MARK: - Home VC에서 바인딩

extension MusicAlbumCell {
    
    func configure(with post: Post) {
        //if let url = URL(string: post.track.coverImage) {
        //    musicAlbumCoverImageView.image = ImageLiterals.img_card_cover
        // }
        userNameLabel.text = post.user.nickname
        userProfileImageView.image = UIImage(named: "img_mock_profile")
        userCommentLabel.text = post.content
        heartCountLabel.text = "\(post.like.count)"
        let scrapIcon = post.isScrapped
        ? IconLiterals.ic_bookmark_fill_24
        : IconLiterals.ic_bookmark_24
    }
    
    func setPlaying(_ isPlaying: Bool) {
        if isPlaying {
            startRotating()
        } else {
            stopRotating()
        }
    }
}

// MARK: - 회전 애니메이션

private extension MusicAlbumCell {

    func startRotating() {
        guard musicAlbumCoverImageView.layer.animation(forKey: "rotation") == nil else { return }

        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.fromValue = 0
        rotation.toValue = Double.pi * 2
        rotation.duration = 8.0              // 한 바퀴 8초 (느긋하게)
        rotation.repeatCount = .infinity
        rotation.isRemovedOnCompletion = false

        musicAlbumCoverImageView.layer.add(rotation, forKey: "rotation")
    }

    func stopRotating() {
        musicAlbumCoverImageView.layer.removeAnimation(forKey: "rotation")
    }
}
