//
//  MusicDetailViewController.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 11/16/25.
//

import UIKit
import Combine

import Then
import SnapKit

final class MusicDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: MusicDetailViewModel
    private var cancellables = Set<AnyCancellable>()
    
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
    
    init(viewModel: MusicDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStyle()
        setupHierarchy()
        setupLayout()
        bind()
        bindNavigationBar()
    }
    
    private func loadData() {
        Task { await viewModel.loadDetail() }
    }
}

private extension MusicDetailViewController {
    // MARK: - Layout
    
    func setupStyle() {
        view.backgroundColor = .white
        
        topOverlayImageView.do {
            $0.contentMode = .scaleAspectFill
            $0.image = ImageLiterals.img_card_cover
            $0.clipsToBounds = true
        }
        
        blurView.alpha = 0.5
        whiteOverlay.backgroundColor = .white.withAlphaComponent(0.7)
        
        albumImageView.do {
            $0.contentMode = .scaleAspectFill
            $0.image = ImageLiterals.img_card_cover
            $0.roundCorners(cornerRadius: 8)
        }
        
        scrapButton.do {
            $0.setImage(IconLiterals.ic_bookmark_24, for: .normal)
            $0.backgroundColor = .gray600
            $0.roundCorners(cornerRadius: 12)
        }
        
        musicStateButton.do {
            var config = UIButton.Configuration.plain()
            config.image = IconLiterals.ic_editor
            config.baseForegroundColor = .dplay_pink
            config.imagePadding = 4
            
            var titleAttr = AttributedString("EDITOR")
            titleAttr.font = .dplayFont(.bodySemi14)
            titleAttr.foregroundColor = .dplay_pink
            config.attributedTitle = titleAttr
            $0.configuration = config
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.dplay_pink.cgColor
            $0.backgroundColor = .white
            $0.roundCorners(cornerRadius: 15)
        }
        
        musicTitle.do {
            $0.setTextStyle(.titleBold18)
            $0.text = "내일에서 온 티켓"
            $0.textColor = .black
            $0.textAlignment = .center
        }
        
        artistLabel.do {
            $0.setTextStyle(.bodySemi14)
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
            $0.roundCorners(cornerRadius: 12)
        }
        
        actionButtons.do {
            $0.axis = .horizontal
            $0.spacing = 8
            $0.distribution = .fillEqually
        }
        
        commentCard.do {
            $0.backgroundColor = .white
            $0.roundCorners(cornerRadius: 12)
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.gray200.cgColor
        }
        
        commentLabel.do {
            $0.setTextStyle(.bodySemi14)
            $0.text = "진짜 나오자마자 들었는데 이 노래가 최고 출근곡, 퇴근곡, 노동곡 다 되는 짱제로! 일하는 매장에서도 수십 번씩 틀고 있어요. 모두가 알아야 돼.."
            $0.numberOfLines = 0
        }
        
        profileImageView.do {
            $0.contentMode = .scaleAspectFill
            $0.roundCorners(cornerRadius: 16)
            $0.image = ImageLiterals.img_mock_profile
            $0.snp.makeConstraints { $0.size.equalTo(32) }
        }
        
        profileName.do {
            $0.setTextStyle(.bodySemi14)
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
        
        contentView.addSubviews(
            topOverlayImageView,
            blurView,
            whiteOverlay,
            navigationBarView,
            albumContainer,
            musicTitle,
            artistLabel,
            actionButtons,
            commentCard
        )
        
        albumContainer.addSubviews(
            albumImageView,
            scrapButton,
            musicStateButton
        )
        
        actionButtons.addArrangedSubviews(playButton, likeButton)
        commentCard.addSubviews(commentLabel, profileStack)
        profileStack.addArrangedSubviews(profileImageView, profileName)
    }
    
    func setupLayout() {
        
        topOverlayImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(250)
        }
        
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
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
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
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(48)
        }
        
        commentCard.snp.makeConstraints {
            $0.top.equalTo(actionButtons.snp.bottom).offset(32)
            $0.horizontalEdges.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview().offset(-40)
        }
        
        commentLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.horizontalEdges.equalToSuperview().inset(12)
        }
        
        profileStack.snp.makeConstraints {
            $0.top.equalTo(commentLabel.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(16)
        }
    }
}

private extension MusicDetailViewController {
    func bind() {
        
        viewModel.$detail
            .receive(on: DispatchQueue.main)
            .sink { [weak self] detail in
                guard let self, let detail else { return }
                
                self.musicTitle.text = detail.title
                self.artistLabel.text = detail.artist
                
                // 이미지 로드 (URL 기반)
                //if let url = URL(string: detail.coverImage) {
                //    self.albumImageView.kf.setImage(with: url)
                //    self.topOverlayImageView.kf.setImage(with: url)
                //}
            }
            .store(in: &cancellables)
    }
    
    func presentReportSheet() {

        guard let window = keyWindow() else { return }

        let sheet = ReportSheetView()
        
        sheet.closeHandler = { [weak sheet] in
            sheet?.dismiss()
        }

        sheet.confirmHandler = { [weak sheet] reason in
            print("신고 사유:", reason.rawValue)
            sheet?.dismiss()
        }

        window.addSubview(sheet)
        sheet.snp.makeConstraints { $0.edges.equalToSuperview() }
        sheet.present()
    }

    func keyWindow() -> UIWindow? {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }
}

// MARK: - Navigation

private extension MusicDetailViewController {
    func bindNavigationBar() {
        navigationBarView.onTapBack = { [weak self] in
            self?.viewModel.didTapBack()
        }
        
        navigationBarView.onTapMenu = { [weak self] in
            self?.presentReportSheet()
        }
    }
}
