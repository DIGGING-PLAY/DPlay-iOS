//
//  MusicDetailViewController.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 11/16/25.
//

import UIKit

import Then
import SnapKit

final class MusicDetailViewController: UIViewController {
    // MARK: - Properties
    
    // MARK: - UI Properties
    
    private let navigationBarView = MusicDetailNavigationBar()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let topOverlayImageView = UIImageView()
    private let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    private let whiteOverlay = UIView()
    
    private let albumContainer = UIView()
    private let albumImageView = UIImageView()
    private let scrapButton = UIButton()
    private let musicStateButton = UIButton()
    private let musicTitle = UILabel()
    private let artistLabel = UILabel()
    
    private let playButton = UIButton()
    private let likeButton = UIButton()
    private var actionButtons = UIStackView()
   
    private let commentCard = UIView()
    private let commentLabel = UILabel()

    private let profileImageView = UIImageView()
    private let profileName = UILabel()
    private let profileStack = UIStackView()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStyle()
        setupHierarchy()
        setupLayout()
    }
}

private extension MusicDetailViewController {
    // MARK: - Layout
    
    func setupStyle() {
        topOverlayImageView.do {
            $0.contentMode = .scaleAspectFill
            $0.image = ImageLiterals.img_card_cover
            $0.clipsToBounds = true
        }
        
        blurView.alpha = 0.9
        whiteOverlay.backgroundColor = .white.withAlphaComponent(0.3)

        albumImageView.do {
            $0.contentMode = .scaleAspectFill
            $0.image = ImageLiterals.img_card_cover
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 8
        }
        
        scrapButton.do {
            $0.setImage(IconLiterals.ic_bookmark_24, for: .normal)
            $0.backgroundColor = .gray600
            $0.layer.cornerRadius = 12
            $0.layer.masksToBounds = true
        }
        
        musicStateButton.do {
            var config = UIButton.Configuration.plain()
            config.image = IconLiterals.ic_editor
            config.baseForegroundColor = .dplay_pink
            config.imagePadding = 4
            config.cornerStyle = .capsule
            
            var titleAttr = AttributedString("EDITOR")
            titleAttr.font = .dplayFont(.bodySemi14)
            titleAttr.foregroundColor = .dplay_pink
            config.attributedTitle = titleAttr
            
            $0.backgroundColor = .white
            $0.configuration = config
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.dplay_pink.cgColor
        }
        
        musicTitle.do {
            $0.font = .dplayFont(.titleBold18)
            $0.text = "내일에서 온 티켓"
            $0.textColor = .black
            $0.textAlignment = .center
        }
        
        artistLabel.do {
            $0.font = .dplayFont(.bodySemi14)
            $0.text = "한로로"
            $0.textColor = .gray400
            $0.textAlignment = .center
        }
        
        playButton.do {
            var config = UIButton.Configuration.filled()
            config.baseBackgroundColor = .dplay_pink
            config.image = IconLiterals.ic_stream_w
            config.imagePadding = 8
            config.cornerStyle = .medium
            
            var titleAttr = AttributedString("재생하기")
            titleAttr.font = .dplayFont(.bodyBold14)
            titleAttr.foregroundColor = .white
            config.attributedTitle = titleAttr
            
            $0.configuration = config
        }

        likeButton.do {
            var config = UIButton.Configuration.bordered()
            config.baseForegroundColor = UIColor.dplay_pink
            config.baseBackgroundColor = .clear
            config.cornerStyle = .medium

            // 아이콘
            config.image = IconLiterals.ic_heart_p
            config.imagePlacement = .leading
            config.imagePadding = 8

            // 텍스트
            var titleAttr = AttributedString("53")
            titleAttr.font = .dplayFont(.bodySemi14)
            titleAttr.foregroundColor = UIColor.dplay_pink
            config.attributedTitle = titleAttr
            $0.configuration = config
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.dplay_pink.cgColor
            $0.layer.cornerRadius = 12
        }
        
        actionButtons.do {
            $0.axis = .horizontal
            $0.spacing = 8
            $0.distribution = .fillEqually
        }
        
        commentCard.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 12
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.gray200.cgColor
        }
        
        commentLabel.do {
            $0.font = .dplayFont(.bodySemi14)
            $0.text = "진짜 나오자마자 들었는데 이 노래가 최고 출근곡, 퇴근곡, 노동곡 다 되는 짱제로! 일하는 매장에서도 수십 번씩 틀고 있어요. 모두가 알아야 돼.."
            $0.numberOfLines = 0
        }
        
        profileImageView.do {
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = 16
            $0.clipsToBounds = true
            $0.image = ImageLiterals.img_mock_profile
            $0.snp.makeConstraints { $0.size.equalTo(32) }
        }
        
       profileName.do {
            $0.font = .dplayFont(.bodySemi14)
            $0.textColor = .gray400
            $0.text = "윤서얌어렵다이거"
        }
        
        profileStack.do {
            $0.axis = .horizontal
            $0.spacing = 6
            $0.alignment = .center
        }
    }
    
    func setupHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(topOverlayImageView)
        contentView.addSubview(blurView)
        contentView.addSubview(whiteOverlay)
        contentView.addSubview(navigationBarView)
        
        contentView.addSubview(albumContainer)
        albumContainer.addSubview(albumImageView)
        albumContainer.addSubview(scrapButton)
        albumContainer.addSubview(musicStateButton)

        contentView.addSubview(musicTitle)
        contentView.addSubview(artistLabel)
        actionButtons.addArrangedSubview(playButton)
        actionButtons.addArrangedSubview(likeButton)
        contentView.addSubview(actionButtons)
        contentView.addSubview(commentCard)
        commentCard.addSubview(commentLabel)
        commentCard.addSubview(profileStack)
        profileStack.addArrangedSubview(profileImageView)
        profileStack.addArrangedSubview(profileName)
    }
    
    
    
    func setupLayout() {
        
        blurView.snp.makeConstraints {
            $0.edges.equalTo(topOverlayImageView)
        }

        whiteOverlay.snp.makeConstraints {
            $0.edges.equalTo(topOverlayImageView)
        }
        
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        navigationBarView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(44)
        }
        
        albumContainer.snp.makeConstraints {
            $0.top.equalTo(navigationBarView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        albumImageView.snp.makeConstraints {
            $0.size.equalTo(180)
            $0.edges.equalToSuperview()
        }
        
        scrapButton.snp.makeConstraints {
            $0.top.equalTo(albumImageView.snp.top).inset(12)
            $0.trailing.equalTo(albumImageView.snp.trailing).inset(12)
            $0.size.equalTo(44)
        }
        
        musicStateButton.snp.makeConstraints {
            $0.top.equalTo(albumImageView.snp.bottom).inset(20)
            $0.centerX.equalToSuperview()
        }
        
        musicTitle.snp.makeConstraints {
            $0.top.equalTo(musicStateButton.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        artistLabel.snp.makeConstraints {
            $0.top.equalTo(musicTitle.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
        }
        
        actionButtons.snp.makeConstraints {
            $0.top.equalTo(artistLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(48)
        }
        
        commentCard.snp.makeConstraints {
            $0.top.equalTo(actionButtons.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview().offset(-40)
        }
        
        commentLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.trailing.equalToSuperview().inset(12)
        }
        
        profileStack.snp.makeConstraints {
            $0.top.equalTo(commentLabel.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(16)
        }
    }
}

#if DEBUG
import SwiftUI

struct MusicDetail_Previews: PreviewProvider {
    static var previews: some View {
        MusicDetailViewController()
            .toPreview()
            .previewDevice("iPhone 15 Pro")
    }
}
#endif

import SwiftUI

extension UIViewController {
    func toPreview() -> some View {
        UIViewControllerPreviewWrapper(self)
    }
}

private struct UIViewControllerPreviewWrapper: UIViewControllerRepresentable {
    let viewController: UIViewController
    
    init(_ vc: UIViewController) {
        self.viewController = vc
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
