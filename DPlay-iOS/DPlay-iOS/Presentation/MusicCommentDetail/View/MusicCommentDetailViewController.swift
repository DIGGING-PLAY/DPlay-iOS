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
import Kingfisher

final class MusicCommentDetailViewController: UIViewController {
    
    // MARK: - Properties

    private let viewModel: MusicCommentDetailViewModel
    private var cancellables = Set<AnyCancellable>()
    // MARK: - UI Properties

    private let navigationBarView = MusicCommentDetailNavigationBarView()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let topOverlayImageView = UIImageView()
    private let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
    private let gradientOverlay = UIView()
    private let gradientLayer = CAGradientLayer()
    
    private let albumContainer = UIView()
    private let albumImageView = UIImageView()
    private let holeView = UIView()
    private let scrapButton = UIButton()
    private let badgeView = BadgeView()
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
    
    private let loadingOverlayView = UIView()
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    
    // MARK: - Life Cycle
    
    init(viewModel: MusicCommentDetailViewModel) {
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
        startLoading()
        bind()
        bindActions()
        bindNavigationBar()
        setupProfileTap()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = gradientOverlay.bounds
    }
    
    private func loadData() {
        startLoading()
        viewModel.startLoad()
    }
}

private extension MusicCommentDetailViewController {
    // MARK: - Layout
    
    func setupStyle() {
        view.backgroundColor = .gray100
        
        topOverlayImageView.do {
            $0.contentMode = .scaleAspectFill
            $0.image = ImageLiterals.img_card_cover
            $0.clipsToBounds = true
        }
        
        blurView.alpha = 0.6
        
        gradientOverlay.do {
            $0.isUserInteractionEnabled = false
        }
        
        gradientLayer.do {
            $0.colors = [
                UIColor.gray100.withAlphaComponent(0.1).cgColor, // 위
                UIColor.gray100.withAlphaComponent(0.5).cgColor, // 중간
                UIColor.gray100.cgColor                            // 아래
            ]
            $0.locations = [0.0, 0.5, 1.0]
            $0.startPoint = CGPoint(x: 0.5, y: 0.0)
            $0.endPoint   = CGPoint(x: 0.5, y: 1.0)
        }
        
        albumImageView.do {
            $0.contentMode = .scaleAspectFill
            $0.image = ImageLiterals.img_card_cover
            $0.roundCorners(cornerRadius: 90)
            $0.layer.borderWidth = 2
            $0.layer.borderColor = UIColor.gray200.cgColor
        }
        
        holeView.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 14
            $0.layer.borderWidth = 2
            $0.layer.borderColor = UIColor.gray200.cgColor
        }
        
        scrapButton.do {
            $0.setImage(IconLiterals.ic_bookmark_24, for: .normal)
            $0.backgroundColor = .gray600
            $0.contentMode = .scaleAspectFill
            $0.roundCorners(cornerRadius: 12)
        }
        
        musicTitle.do {
            $0.text = "내일에서 온 티켓"
            $0.textColor = .dplay_black
            $0.numberOfLines = 2
            $0.textAlignment = .center
            $0.setTextStyle(.titleBold18)
        }
        
        artistLabel.do {
            $0.text = "한로로"
            $0.textColor = .gray400
            $0.numberOfLines = 0
            $0.textAlignment = .center
            $0.setTextStyle(.bodySemi14)
        }
        
        playButton.do {
            var config = UIButton.Configuration.filled()
            config.background.backgroundColor = .dplay_pink
            config.image = IconLiterals.ic_stream_w
            config.imagePadding = 8
            config.cornerStyle = .medium
            
            config.cornerStyle = .fixed
            config.background.cornerRadius = 13
            config.background.strokeColor = .dplay_pink
            config.background.strokeWidth = 1
            
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
            
            config.cornerStyle = .fixed
            config.background.cornerRadius = 13
            config.background.strokeColor = .dplay_pink
            config.background.strokeWidth = 1
            
            // 텍스트
            var titleAttr = AttributedString("0")
            titleAttr.font = .dplayFont(.bodySemi14)
            titleAttr.foregroundColor = UIColor.dplay_pink
            config.attributedTitle = titleAttr
            $0.configuration = config
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
            $0.text = "진짜 나오자마자 들었는데 이 노래가 최고 출근곡, 퇴근곡, 노동곡 다 되는 짱제로! 일하는 매장에서도 수십 번씩 틀고 있어요. 모두가 알아야 돼.."
            $0.numberOfLines = 0
            $0.setTextStyle(.bodySemi14)
        }
        
        profileImageView.do {
            $0.contentMode = .scaleToFill
            $0.clipsToBounds = true
            $0.roundCorners(cornerRadius: 16)
            $0.image = ImageLiterals.img_mock_profile
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.gray200.cgColor
            $0.snp.makeConstraints { $0.size.equalTo(32) }
        }
        
        profileName.do {
            $0.textColor = .gray400
            $0.text = "윤서얌어렵다이거"
            $0.setTextStyle(.bodySemi14)
        }
        
        profileStack.do {
            $0.axis = .horizontal
            $0.spacing = 6
            $0.alignment = .center
        }
        
        loadingOverlayView.do {
            $0.backgroundColor = .white
            $0.isHidden = true
        }
        
        loadingIndicator.do {
            $0.hidesWhenStopped = true
        }
    }
    
    func setupHierarchy() {
        view.backgroundColor = .gray100
        
        // 1. 배경 이미지들
        view.addSubview(topOverlayImageView)
        view.addSubview(blurView)
        view.addSubview(gradientOverlay)
        
        // 2. 스크롤뷰
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // 3. 네비게이션바 (투명하게 보여야 하므로 스크롤뷰 위에)
        view.addSubview(navigationBarView)
        
        // 4. 로딩 오버레이 (가장 위에)
        view.addSubview(loadingOverlayView)
        loadingOverlayView.addSubview(loadingIndicator)
        
        scrollView.contentInsetAdjustmentBehavior = .never
        gradientOverlay.layer.addSublayer(gradientLayer)
        
        // contentView에는 배경 제외한 나머지만
        contentView.addSubviews(
            albumContainer,
            musicTitle,
            artistLabel,
            actionButtons,
            commentCard
        )
        
        albumImageView.addSubview(holeView)
        albumContainer.addSubviews(
            albumImageView,
            scrapButton,
            badgeView
        )
        
        actionButtons.addArrangedSubviews(playButton, likeButton)
        commentCard.addSubviews(commentLabel, profileStack)
        profileStack.addArrangedSubviews(profileImageView, profileName)
    }
    
    func setupLayout() {
        
        topOverlayImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(200)
        }
        
        blurView.snp.makeConstraints {
            $0.edges.equalTo(topOverlayImageView)
        }
        
        gradientOverlay.snp.makeConstraints {
            $0.edges.equalTo(topOverlayImageView)
        }
        
        navigationBarView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(44)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(navigationBarView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        
        contentView.snp.makeConstraints {
            $0.top.equalTo(scrollView.contentLayoutGuide)
            $0.leading.trailing.bottom.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        loadingOverlayView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        loadingIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        albumContainer.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.centerX.equalToSuperview()
        }
        
        albumImageView.snp.makeConstraints {
            $0.size.equalTo(180)
            $0.edges.equalToSuperview()
        }
        
        holeView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(28)
        }
        
        scrapButton.snp.makeConstraints {
            $0.top.equalTo(albumImageView.snp.top)
            $0.trailing.equalTo(albumImageView.snp.trailing)
            $0.size.equalTo(44)
        }
        
        badgeView.snp.makeConstraints {
            $0.top.equalTo(albumImageView.snp.bottom).inset(30)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(32)
        }
        
        musicTitle.snp.makeConstraints {
            $0.top.equalTo(badgeView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.leading.greaterThanOrEqualToSuperview().inset(16)
            $0.trailing.lessThanOrEqualToSuperview().inset(16)
        }
        
        artistLabel.snp.makeConstraints {
            $0.top.equalTo(musicTitle.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
            $0.leading.greaterThanOrEqualToSuperview().inset(16)
            $0.trailing.lessThanOrEqualToSuperview().inset(16)
        }
        
        actionButtons.snp.makeConstraints {
            $0.top.equalTo(artistLabel.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(48)
        }
        
        commentCard.snp.makeConstraints {
            $0.top.equalTo(actionButtons.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
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

private extension MusicCommentDetailViewController {
    func bind() {
        
        viewModel.$detail
            .receive(on: DispatchQueue.main)
            .sink { [weak self] detail in
                guard let self, let detail else { return }
                self.stopLoading()
                
                // 텍스트
                self.musicTitle.text = detail.track.title
                self.artistLabel.text = detail.track.artist
                self.commentLabel.text = detail.content
                self.profileName.text = detail.user.nickname
                
                // 이미지
                if let coverURL = URL(string: detail.track.coverImageURL) {
                    self.albumImageView.kf.setImage(with: coverURL)
                    self.topOverlayImageView.kf.setImage(with: coverURL)
                } else {
                    self.albumImageView.image = ImageLiterals.img_card_cover
                    self.topOverlayImageView.image = ImageLiterals.img_card_cover
                }
                
                // 사용자 프로필 없으면 기본 이미지 지정 해줘야 함
                if let profileImageString = detail.user.profileImage,
                   let profileImageURL = URL(string: profileImageString)
                {
                    profileImageView.setImage(url: profileImageURL)
                } else {
                    profileImageView.image = ImageLiterals.img_default_profile
                }
                
                // editor 작성 글이면 기본 이미지 + 터치 불가 (프로필 이동 불가)
                if detail.user.isAdmin == true {
                    self.profileImageView.image = ImageLiterals.img_editor_profile
                    self.profileStack.isUserInteractionEnabled = false
                } else {
                    self.profileStack.isUserInteractionEnabled = true
                }
                
                // 좋아요 버튼
                self.updateLikeButton(detail.like)
                
                // 스크랩 버튼
                self.updateScrapButton(isScrapped: detail.isScrapped)
                
                // 작성자 여부 → 메뉴 표시 제어
                self.navigationBarView.configure(
                    displayDate: detail.displayDate,
                    isHost: detail.isHost
                )
            }
            .store(in: &cancellables)
        
        viewModel.$badge
            .receive(on: DispatchQueue.main)
            .sink { [weak self] badge in
                self?.badgeView.configure(badge: badge)
            }
            .store(in: &cancellables)
    }
    
    func bindActions() {

        likeButton.addAction(
            UIAction { [weak self] _ in
                Task { await self?.viewModel.toggleLike() }
            },
            for: .touchUpInside
        )

        scrapButton.addAction(
            UIAction { [weak self] _ in
                self?.handleScrapTapped()
            },
            for: .touchUpInside
        )

        playButton.addAction(
            UIAction { [weak self] _ in
                self?.viewModel.didTapPreview()
            },
            for: .touchUpInside
        )
    }
    
    func startLoading() {
        loadingOverlayView.isHidden = false
        loadingIndicator.startAnimating()
        view.isUserInteractionEnabled = false
    }
    
    func stopLoading() {
        loadingIndicator.stopAnimating()
        loadingOverlayView.isHidden = true
        view.isUserInteractionEnabled = true
    }

    func presentReportSheet() {

        guard let window = UIApplication.shared.keyWindow else { return }
        
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
    
    func setupProfileTap() {
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(didTapProfile)
        )
        profileStack.addGestureRecognizer(tap)
        profileStack.isUserInteractionEnabled = true
    }
}

@objc private extension MusicCommentDetailViewController {
    func didTapProfile() {
        viewModel.goToUserProfile()
    }
}

private extension MusicCommentDetailViewController {

    func updateLikeButton(_ like: Like) {
        var config = likeButton.configuration

        config?.image = like.isLiked
            ? IconLiterals.ic_heart_p_fill
            : IconLiterals.ic_heart_p

        var title = AttributedString("\(like.count)")
        title.font = .dplayFont(.bodySemi14)
        title.foregroundColor = .dplay_pink
        config?.attributedTitle = title

        config?.background.backgroundColor =
            like.isLiked ? .dplay_pink100 : .white

        likeButton.configuration = config
    }


    func updateScrapButton(isScrapped: Bool) {
        let image = isScrapped
            ? IconLiterals.ic_bookmark_fill_24
            : IconLiterals.ic_bookmark_24

        scrapButton.setImage(image, for: .normal)
    }
    
    func handleScrapTapped() {
        let isScrapped = viewModel.detail?.isScrapped == true

        Task { await viewModel.toggleScrap() }

        guard isScrapped == false else { return }

        ToastManager.shared.show(
            message: "보관함에 추가했어요",
            actionText: "보러가기",
            action: { [weak self] in
                self?.viewModel.goToScrapTab()
            }
        )
    }
}


// MARK: - Navigation

private extension MusicCommentDetailViewController {

    func bindNavigationBar() {
        navigationBarView.onTapBack = { [weak self] in
            self?.viewModel.didTapBack()
        }

        navigationBarView.onTapDelete = { [weak self] in
            self?.showDeleteModal()
        }

        navigationBarView.onTapReport = { [weak self] in
            self?.presentReportSheet()
        }
    }
    
    func showDeleteModal() {
        let modal = DPlayButtonModalViewController(
            type: .warning,
            primaryButtonTitle: "삭제하기",
            secondaryButtonTitle: "취소하기",
            primaryAction: { [weak self] in
                AlertWindowManager.shared.present(
                    title: "정말 삭제하시겠어요?",
                    message: nil,
                    actions: [
                        AlertAction(
                            buttonTitle: "취소",
                            style: .secondaryLeft,
                            onTap: {
                                print("머무리기")
                            }),
                        AlertAction(
                            buttonTitle: "삭제하기",
                            style: .primaryRight,
                            onTap: {
                                Task { await self?.viewModel.deletePost() }
                            })
                    ],
                )
            },
            secondaryAction: {}
        )

        if let sheet = modal.sheetPresentationController {
            sheet.detents = [.custom { _ in 110 }]
            sheet.prefersGrabberVisible = false
        }

        present(modal, animated: true)
    }
}
