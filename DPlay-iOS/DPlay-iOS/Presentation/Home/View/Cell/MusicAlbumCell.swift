//
//  MusicAlbumCell.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 11/14/25.
//

import UIKit

import SnapKit
import Then
import Kingfisher

final class MusicAlbumCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = MusicAlbumCell.className
    // 같은 음악 앨범 커버가 같이 돌아가는 걸 방지 하기 위함, 같은 노래라도 내가 누른 음악 커바만 돌아가기
    var cellId: UUID = UUID()
    var onTapPlay: (() -> Void)?
    var onTapLike: (() -> Void)?
    var onTapProfile: (() -> Void)?
    
    // MARK: - UI Properties
    
    private let musicAlbumCoverImageView = UIImageView()
    private let cardBackgroundView = UIView()
    private let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    private let gradientOverlay = UIView()
    private let gradientLayer = CAGradientLayer()
    
    private let profileTapAreaView = UIView()
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        stopRotating()
        
        // 빠르게 스크롤시 이전셀 이미지 보이는 현상 방지
        musicAlbumCoverImageView.kf.cancelDownloadTask()
    }
}

private extension MusicAlbumCell {
    
    func setupStyle() {
        backgroundColor = .clear
        
        musicAlbumCoverImageView.do {
            $0.contentMode = .scaleAspectFill
            $0.roundCorners(cornerRadius: 128)
            $0.image = ImageLiterals.img_card_cover
            $0.layer.borderWidth = 2
            $0.layer.borderColor = UIColor.gray200.cgColor
        }
        
        cardBackgroundView.do {
            $0.backgroundColor = UIColor.dplay_pink.withAlphaComponent(0.45)
            $0.roundCorners(
                cornerRadius: 12,
                maskedCorners: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            )
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.dplay_pink.cgColor
        }
        
        blurView.alpha = 1.0
        
        gradientOverlay.do {
            $0.isUserInteractionEnabled = false
        }
        
        gradientLayer.do {
            $0.colors = [
                UIColor.white.withAlphaComponent(0.05).cgColor,
                UIColor.white.withAlphaComponent(0.25).cgColor,
                UIColor.white.withAlphaComponent(0.6).cgColor
            ]
            gradientLayer.locations = [0.0, 0.65, 1.0]
            $0.startPoint = CGPoint(x: 0.5, y: 0.0)
            $0.endPoint   = CGPoint(x: 0.5, y: 1.0)
        }
        
        userProfileImageView.do {
            $0.contentMode = .scaleToFill
            $0.clipsToBounds = true
            $0.roundCorners(cornerRadius: 14)
            $0.image = ImageLiterals.img_default_profile
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.gray200.cgColor
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
        
        gradientOverlay.layer.addSublayer(gradientLayer)
        
        cardBackgroundView.addSubviews(
            blurView,
            gradientOverlay
        )
        
        cardBackgroundView.addSubviews(
            profileTapAreaView,
            userCommentQuoteUpImageView,
            userCommentQuoteDownImageView,
            userCommentLabel,
            userHeartButton,
            heartCountLabel,
            musicStreamingButton
        )
        
        profileTapAreaView.addSubviews(
            userProfileImageView,
            userNameLabel
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
        
        blurView.snp.makeConstraints { $0.edges.equalToSuperview()
        }
        
        gradientOverlay.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        profileTapAreaView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.height.equalTo(44)
            $0.width.greaterThanOrEqualTo(120)
        }
        
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
            $0.size.equalTo(24)
        }
        
        heartCountLabel.snp.makeConstraints {
            $0.centerY.equalTo(userHeartButton.snp.centerY).offset(-2)
            $0.leading.equalTo(userHeartButton.snp.trailing).offset(4)
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
    func setupTarget() {
        musicStreamingButton.addTarget(
            self,
            action: #selector(playTapped),
            for: .touchUpInside
        )
        
        userHeartButton
            .addTarget(
                self,
                action: #selector(
                    handleLikeTapped
                ),
                for: .touchUpInside
            )
        
        let profileTap = UITapGestureRecognizer(
            target: self,
            action: #selector(handleProfileTapped)
        )
        profileTapAreaView.isUserInteractionEnabled = true
        profileTapAreaView.addGestureRecognizer(profileTap)
    }
}

@objc private extension MusicAlbumCell {
    
    func playTapped() {
        onTapPlay?()
    }
    
    func handleLikeTapped() {
        onTapLike?()
    }
    
    func handleProfileTapped() {
        print("프로필 눌림")
        onTapProfile?()
    }
}

// MARK: - Home VC에서 바인딩

extension MusicAlbumCell {
    
    func configure(with post: Post) {
        if let url = URL(string: post.track.coverImage) {
            musicAlbumCoverImageView.kf.setImage(
                with: url,
                placeholder: nil,
                options: [
                    .transition(.fade(0.2)),
                    .cacheOriginalImage
                ]
            )
        } else {
            musicAlbumCoverImageView.image = ImageLiterals.img_card_cover
        }
        userNameLabel.text = post.user.nickname
       
        if let profileImageString = post.user.profileImage,
           let profileImageURL = URL(string: profileImageString)
        {
            userProfileImageView.setImage(url: profileImageURL)
        } else {
            userProfileImageView.image = ImageLiterals.img_default_profile
        }
        
        userCommentLabel.text = post.content
        let image = post.like.isLiked
            ? IconLiterals.ic_heart_w_fill
            : IconLiterals.ic_heart_w
        userHeartButton.setImage(image, for: .normal)
        heartCountLabel.text = "\(post.like.count)"
        
        // editor 작성 글이면 기본 이미지, 및 터치 불가능
        if post.user.isAdmin == true {
            userProfileImageView.image = ImageLiterals.img_editor_profile
            profileTapAreaView.isUserInteractionEnabled = false
        } else {
            profileTapAreaView.isUserInteractionEnabled = true
        }
    }
    
    func setPlaying(_ isPlaying: Bool) {
        if isPlaying {
            startRotating()
        } else {
            stopRotating()
        }
    }
    
    func updateLikeUI(_ like: Like) {
        let image = like.isLiked
            ? IconLiterals.ic_heart_w_fill
            : IconLiterals.ic_heart_w
        userHeartButton.setImage(image, for: .normal)
        heartCountLabel.text = "\(like.count)"
    }
}

// MARK: - 회전 애니메이션

private extension MusicAlbumCell {
    
    func startRotating() {
        guard musicAlbumCoverImageView.layer.animation(forKey: "rotation") == nil else { return }
        
        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.fromValue = 0
        rotation.toValue = Double.pi * 2
        rotation.duration = 10.0              // 한 바퀴 8초 (느긋하게)
        rotation.repeatCount = .infinity
        rotation.isRemovedOnCompletion = false
        
        musicAlbumCoverImageView.layer.add(rotation, forKey: "rotation")
    }
    
    func stopRotating() {
        musicAlbumCoverImageView.layer.removeAnimation(forKey: "rotation")
    }
}
