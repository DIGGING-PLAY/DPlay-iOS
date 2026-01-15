//
//  ViewController.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 10/30/25.
//

import UIKit
import Combine

import SnapKit
import Then

private enum PageState: Equatable{
    case post(Int)   // n번째 게시글
    case locked      // 잠금 셀
    case invalid     // 계산 오류, 데이터 불일치
}

final class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: HomeViewModel
    private var cancellables = Set<AnyCancellable>()
    private var playingCellId: UUID?
    private var currentPage: PageState = .post(0)
    private var isRefreshing = false
    private var scrapToggleIndex: Int?
    
    // MARK: - UI Properties
    
    private let navigationBarView = HomeNavigationBarView()
    private let todayDateLabel = UILabel()
    private let refreshButton = UIButton()
    
    private let questionContainerView = UIView()
    private let questionImage = UIImageView()
    private let questionLabel = UILabel()
    private let questionTitleLabel = UILabel()
    
    private var popupView: RecommendationPopupView?
    private var musicStateBadgeView = HomeFeedBadgeView()
    private let musicScrapButton = UIButton()
    private let editorCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    
    // Haptic 관련
    private let hapticGenerator = UIImpactFeedbackGenerator(style: .light)
    private var lastHapticIndex: Int?
    
    // MARK: - Life Cycle
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
        hapticGenerator.prepare()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupDelegate()
        setupTarget()
        bindNavigationBar()
        bind()
        bindAudioState()
    }
}

private extension HomeViewController {
    
    // MARK: - Layout
    
    func setupStyle() {
        view.backgroundColor = .white
        
        todayDateLabel.do {
            $0.text = "10월 12일의 발견"
            $0.setTextStyle(.titleBold18)
            $0.textColor = .dplay_black
        }
        
        refreshButton.do {
            let image = IconLiterals.ic_refresh
                .resized(to: CGSize(width: 28, height: 28))
                .withRenderingMode(.alwaysOriginal)
            $0.setImage(image, for: .normal)
            $0.imageView?.contentMode = .scaleAspectFit
        }
        
        questionContainerView.do {
            $0.backgroundColor = .gray100
            $0.roundCorners(cornerRadius: 12)
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.gray200.cgColor
        }
        
        questionImage.do {
            $0.image = IconLiterals.ic_dplay_smallLogo
            $0.contentMode = .scaleAspectFit
        }
        
        questionLabel.do {
            $0.text = "오늘의 질문"
            $0.textColor = .dplay_pink
            $0.setTextStyle(.bodySemi14)
        }
        
        questionTitleLabel.do {
            $0.text = "여행 갈 때 플레이리스트에 꼭 넣는 노래는?"
            $0.textColor = .dplay_black
            $0.setTextStyle(.bodySemi14)
        }
        
        musicScrapButton.do {
            $0.setImage(IconLiterals.ic_bookmark_24, for: .normal)
            $0.backgroundColor = .gray600
            $0.roundCorners(cornerRadius: 12)
        }
        
        editorCollectionView.do {
            $0.backgroundColor = .clear
            $0.setCollectionViewLayout(makeEditorLayout(), animated: false)
            $0.register(MusicAlbumCell.self, forCellWithReuseIdentifier: MusicAlbumCell.identifier)
            $0.register(LockedAlbumCell.self, forCellWithReuseIdentifier: LockedAlbumCell.identifier)
            $0.showsHorizontalScrollIndicator = false
        }
    }
    
    func setupHierarchy() {
        view.addSubviews(
            navigationBarView,
            todayDateLabel,
            refreshButton,
            questionContainerView,
            musicStateBadgeView,
            editorCollectionView,
            musicScrapButton
        )
        
        questionContainerView.addSubviews(
            questionImage,
            questionLabel,
            questionTitleLabel
        )
    }
    
    func setupLayout() {
        navigationBarView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(48)
        }
        
        todayDateLabel.snp.makeConstraints {
            $0.top.equalTo(navigationBarView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(16)
        }
        
        refreshButton.snp.makeConstraints {
            $0.centerY.equalTo(todayDateLabel)
            $0.leading.equalTo(todayDateLabel.snp.trailing).offset(8)
            $0.size.equalTo(20)
        }
        
        questionContainerView.snp.makeConstraints {
            $0.top.equalTo(todayDateLabel.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(66)
        }
        
        questionImage.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.leading.equalToSuperview().inset(12)
            $0.size.equalTo(20)
        }
        
        questionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.leading.equalTo(questionImage.snp.trailing).offset(4)
        }
        
        questionTitleLabel.snp.makeConstraints {
            $0.top.equalTo(questionImage.snp.bottom).offset(4)
            $0.horizontalEdges.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview().inset(12)
        }
        
        musicStateBadgeView.snp.makeConstraints {
            $0.top.equalTo(questionContainerView.snp.bottom).offset(32)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(32)
            $0.width.equalTo(100)
        }
        
        musicScrapButton.snp.makeConstraints {
            $0.trailing.equalTo(editorCollectionView.snp.trailing).inset(view.bounds.width * 0.15)
            $0.top.equalTo(editorCollectionView.snp.top)
            $0.size.equalTo(44)
        }
        
        editorCollectionView.snp.makeConstraints {
            $0.top.equalTo(musicStateBadgeView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}

private extension HomeViewController {
    
    // MARK: - Delegate & Target & Data load
    
    func setupDelegate() {
        editorCollectionView.delegate = self
        editorCollectionView.dataSource = self
    }
    
    func setupTarget() {
        refreshButton.addAction(
            UIAction { [weak self] _ in
                self?.refresh()
            },
            for: .touchUpInside
        )
        
        musicScrapButton.addAction(
            UIAction { [weak self] _ in
                self?.handleScrapTapped()
            },
            for: .touchUpInside
        )
    }
    
    func refresh() {
        Task {
            isRefreshing = true
            AudioPlayerManager.shared.stop()
            playingCellId = nil
            await viewModel.loadHome()
            resetToFirstPage()
        }
    }
    
    func loadData() {
        Task { await viewModel.loadHome() }
    }
}

@objc private extension HomeViewController {
    
    //MARK: - @objc Method
    
    func handleScrapTapped() {
        guard case .post(let index) = currentPage else { return }
        
        let post = viewModel.posts[index]
        scrapToggleIndex = index
        
        Task {
            await viewModel.toggleScrap(postId: post.id)
        }
        
        ToastManager.shared.show(
            message: post.isScrapped ? "보관함에서 삭제했어요" : "보관함에 추가했어요",
            actionText: "보러가기",
            action: { [weak self] in
                self?.viewModel.goToScrapTab()
            }
        )
    }
}

private extension HomeViewController {
    
    // MARK: - Layout Constants
    
    enum Layout {
        static let cardHeight: CGFloat = 300
        static let cardFraction: CGFloat = 0.7 // 화면 대비 카드 전체 너비 비율
        static let horizontalInsetFraction: CGFloat = (1 - cardFraction) / 2 // 양쪽 여백 비율
        static let groupSpacingFraction: CGFloat = 0.08 // 카드 간 간격 비율
    }
    
    // MARK: - Make Layout
    
    func makeEditorLayout() -> UICollectionViewLayout {
        
        return UICollectionViewCompositionalLayout { section, env in
            // 현재 화면 width
            let containerWidth = env.container.contentSize.width
            
            // 아이템 크기 (가로는 비율, 세로는 그룹에 의해 결정)
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            // 그룹 크기
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(Layout.cardFraction),
                heightDimension: .absolute(Layout.cardHeight)
            )
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitems: [item]
            )
            
            // Section 세팅
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPaging
            
            section.interGroupSpacing = containerWidth * Layout.groupSpacingFraction
            
            // 좌우 inset도 비율 기반
            section.contentInsets = NSDirectionalEdgeInsets(
                top: 0,
                leading: containerWidth * Layout.horizontalInsetFraction,
                bottom: 0,
                trailing: containerWidth * Layout.horizontalInsetFraction
            )
            
            /// 스크롤 이벤트 잡는 부분 - scrollViewDidScroll 같은 효과
            section.visibleItemsInvalidationHandler = { [weak self] _, offset, env in
                guard let self else { return }
                // 1. 현재 스크롤 위치 판단
                let page = self.pageNumber(offsetX: offset.x, width: env.container.contentSize.width)
                // 2. 페이지 상태 갱신
                self.updateCurrentPage(page)
                // 3. 페이지 바뀔 때 햅틱
                self.playHapticIfNeeded(page)
            }
            return section
        }
    }
    
    // MARK: - 현재 페이지 상태 관련
    
    /// 페이지 계산 로직 현재 보여지는 카드뷰 index(0, 1, 2, …) 을 계산
    /// 반환값: 현재 카드뷰 인덱스
    func pageNumber(offsetX: CGFloat, width: CGFloat) -> Int {
        let pageWidth = width * Layout.cardFraction
        return Int((offsetX + pageWidth / 2) / pageWidth)
    }
    
    /// 페이지 상태 갱신
    /*
     posts.count = 5
     index: 0 1 2 3 4 [5]
     ↑
     locked cell
     */
    func updateCurrentPage(_ page: Int) {
        
        let nextPage: PageState
        
        if page < viewModel.posts.count {
            nextPage = .post(page)
        } else if page == viewModel.posts.count && viewModel.isLocked {
            nextPage = .locked
        } else {
            nextPage = .invalid
        }
        if currentPage == nextPage { return }
        currentPage = nextPage
        
        onPageChanged()
    }
    
    /// 페이지 변경 시 발생하는 이벤트 묶음
    func onPageChanged() {
        updateTopUI()
        showLockedPopupIfNeeded()
    }
    
    /// 현재 페이지 상태에 맞게 상단 UI 업데이트 제어 함수
    /// viewModel.posts.indices.contains(index) 이유 : 새로고침 직후 등  Posts 안에 알맞은 인덱스가 존재할때만 UI 업데이트
    func updateTopUI() {
        
        switch currentPage {
        case .post(let index):
            guard viewModel.posts.indices.contains(index) else {
                hideTopUI()
                return
            }
            
            let post = viewModel.posts[index]
            showTopUI(post)
            
        case .locked:
            hideTopUI()
        case .invalid:
            return
        }
    }
    
    func showTopUI(_ post: Post) {
        musicStateBadgeView.configure(badge: post.badges)
        musicScrapButton.isHidden = false
        
        let image = post.isScrapped
        ? IconLiterals.ic_bookmark_fill_24
        : IconLiterals.ic_bookmark_24
        
        musicScrapButton.setImage(image, for: .normal)
    }
    
    func hideTopUI() {
        musicStateBadgeView.hide()
        musicScrapButton.isHidden = true
    }
    
    /// 새로고침 이후 스크롤 UI 및 Cell 첫 번째로 위치하게 하는 메서드
    func resetToFirstPage() {
        currentPage = .post(0)
        lastHapticIndex = nil
        
        editorCollectionView.scrollToItem(
            at: IndexPath(item: 0, section: 0),
            at: .centeredHorizontally,
            animated: true
        )
        
        onPageChanged()
    }
    
    // MARK: - PopUp & Haptic
    
    /// 팝업 표시 함수
    /// - currentPage .locked 상태이고 isLocked가 참일때 스크롤시 팝업 표시
    func showLockedPopupIfNeeded() {
        if currentPage == .locked && viewModel.isLocked {
            showLockedPopup()
        }
    }
    
    /// 햅틱 발생 함수
    func playHapticIfNeeded(_ page: Int) {
        if lastHapticIndex == page { return }
        
        lastHapticIndex = page
        hapticGenerator.impactOccurred()
        hapticGenerator.prepare()
    }
}

// MARK: - Popup Methods

private extension HomeViewController {
    
    func showLockedPopup() {
        guard popupView == nil else { return }
        guard let window = UIApplication.shared.keyWindow else { return }
        
        let popup = RecommendationPopupView()
        popup.configure(
            action: { [weak self] in
                self?.hidePopup()
            },
            close: { [weak self] in
                self?.hidePopup()
            }
        )
        
        self.popupView = popup
        window.addSubview(popup)
        
        popup.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        popup.alpha = 0
        UIView.animate(withDuration: 0.25) {
            popup.alpha = 1
        }
    }
    
    func hidePopup() {
        guard let popup = popupView else { return }
        
        UIView.animate(withDuration: 0.25, animations: {
            popup.alpha = 0
        }) { _ in
            popup.removeFromSuperview()
            self.popupView = nil
        }
    }
}

private extension HomeViewController {
    
    // MARK: - 바인딩 관련
    
    func bindNavigationBar() {
        navigationBarView.onTapMenu = { [weak self] in
            guard let self else { return }
            
            viewModel.goToMonthlyQuestion()
        }
    }
    
    func bind() {
        // Posts 데이터 바인딩
        viewModel.$posts
            .receive(on: DispatchQueue.main)
            .sink { [weak self] posts in
                guard let self else { return }
                
                // 스크랩 토글에 의한 이벤트일 경우: 셀 리로드 없이 상단 UI만 업데이트
                if self.scrapToggleIndex != nil {
                    self.scrapToggleIndex = nil
                    self.updateTopUI()
                    return
                }
                
                // 일반 데이터 로딩/새로고침인 경우: 전체 리로드
                self.editorCollectionView.reloadData()
                
                if self.isRefreshing {
                    self.resetToFirstPage()
                    self.isRefreshing = false
                } else {
                    // 앱 최초 진입 대응
                    self.updateTopUI()
                }
            }
            .store(in: &cancellables)
        
        // Question 데이터 바인딩
        viewModel.$question
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] question in
                guard let self else { return }
                
                self.questionTitleLabel.text = question.title
                self.todayDateLabel.text = self.formatDate(question.date)
            }
            .store(in: &cancellables)
    }
    
    
    // MARK: - Cell 앨범 커버 회전
    
    /// AudioPlayerManager를 구독하고 지금 화면에 보이는 MusicAlbumCell들을 전부 순회하면서, 각 셀이 가리키는 트랙 ID와
    /// 현재 재생 중인 오디오의 트랙 ID를 비교하여 맞으면 해당 cell의 앨범 커버를 회전 시킴
    func bindAudioState() {
        AudioPlayerManager.shared.$currentTrackId
            .combineLatest(AudioPlayerManager.shared.$isPlaying)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] trackId, isPlaying in
                guard let self else { return }
                
                for cell in self.editorCollectionView.visibleCells {
                    guard
                        let albumCell = cell as? MusicAlbumCell,
                        let indexPath = self.editorCollectionView.indexPath(for: albumCell)
                    else { continue }
                    
                    let post = self.viewModel.posts[indexPath.item]
                    let shouldRotate =
                    post.track.id == trackId &&   // 지금 재생 중인 노래인가?
                    albumCell.cellId == playingCellId && // 내가 눌렀던 그 셀인가? (같은 앨범이라도)
                    isPlaying                     // 실제로 재생 중인가?
                    
                    albumCell.setPlaying(shouldRotate)
                }
            }
            .store(in: &cancellables)
    }
    
    func formatDate(_ dateString: String) -> String {
        // "2025-10-19" → "10월 19일의 발견"
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = formatter.date(from: dateString) else {
            return ""
        }
        
        let displayFormatter = DateFormatter()
        displayFormatter.locale = Locale(identifier: "ko_KR")
        displayFormatter.dateFormat = "M월 d일의 발견"
        
        return displayFormatter.string(from: date)
    }
}

// MARK: - UICollectionView

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = viewModel.posts.count
        return viewModel.isLocked ? count + 1 : count // 잠금 상태면 Lock Cell 생성 필요
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let postCount = viewModel.posts.count
        
        // 마지막 + isLocked → 잠금 셀
        if viewModel.isLocked && indexPath.item == postCount {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: LockedAlbumCell.identifier,
                for: indexPath
            ) as! LockedAlbumCell
            return cell
        }
        
        // 일반 게시글 셀
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MusicAlbumCell.identifier,
            for: indexPath
        ) as! MusicAlbumCell
        
        let post = viewModel.posts[indexPath.item]
        cell.configure(with: post)
        
        cell.onTapPlay = { [weak self] in
            self?.playingCellId = cell.cellId
            self?.viewModel.didTapPreview(post: post, playCellId: cell.cellId)
        }
        
        cell.onTapLike = { [weak self] in
            Task {
                await self?.viewModel.toggleLike(postId: post.id)
            }
        }
        
        cell.onTapProfile = { [weak self] in
            self?.viewModel.didTapUserProfile(userId: post.user.id)
        }
        
        return cell
    }
    
    /// 셀이 재사용 되기 때문에 애니메이션이 날아감
    /// 셀이 보일때 이 셀이 회전 되어야 하는 셀인지를 판단해서 계속 음악 재생중에 앨범 커버가 돌도록 구현
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        guard let albumCell = cell as? MusicAlbumCell else { return }
        
        let post = viewModel.posts[indexPath.item]
        
        let shouldRotate =
        post.track.id == AudioPlayerManager.shared.currentTrackId &&
        albumCell.cellId == playingCellId && AudioPlayerManager.shared.isPlaying
        
        albumCell.setPlaying(shouldRotate)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let post = viewModel.posts[indexPath.item]
        viewModel.didSelectPost(post)
    }
    
    /// 셀을 선택하기 직전에 무조건 호출됨
    /// 글 작성 안했으면 마지막 LockedAlbumCell에서 터치 불가 popupView 띄우기
    func collectionView(
        _ collectionView: UICollectionView,
        shouldSelectItemAt indexPath: IndexPath
    ) -> Bool {
        
        if viewModel.isLocked && indexPath.item == viewModel.posts.count {
            showLockedPopup()
            return false
        }
        return true
    }
}
