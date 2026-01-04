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

final class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: HomeViewModel
    private var cancellables = Set<AnyCancellable>()
    private var playingCellId: UUID?

    // MARK: - UI Properties
    
    private let navigationBarView = HomeNavigationBarView()
    private let todayDateLabel = UILabel()
    private let refreshButton = UIButton()
    
    private let questionContainerView = UIView()
    private let questionImage = UIImageView()
    private let questionLabel = UILabel()
    private let questionTitleLabel = UILabel()
    
    private var popupView: RecommendationPopupView?
    private let musicStateButton = UIButton()
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
            musicStateButton,
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
        
        musicStateButton.snp.makeConstraints {
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
            $0.top.equalTo(musicStateButton.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
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

            /// 스크롤 이벤트 잡는 부분 - 마지막 cell에서 isLocked가 참일때 스크롤시 팝업 표시
            section.visibleItemsInvalidationHandler = { items, offset, env in
                
                // 현재 페이지 계산
                let pageWidth = env.container.contentSize.width * Layout.cardFraction
                let currentPage = Int((offset.x + pageWidth / 2) / pageWidth)

                // 마지막 페이지(= locked 셀) 접근 시 팝업 표시
                if currentPage == self.viewModel.posts.count + 1,
                   self.viewModel.isLocked {
                    self.showLockedPopup()
                }
                
                // 이전 인덱스와 다를 때만 햅틱 발생
                if self.lastHapticIndex != currentPage {
                    self.lastHapticIndex = currentPage
                    self.hapticGenerator.impactOccurred()
                    self.hapticGenerator.prepare()
                }
            }

            return section
        }
    }
}

@objc private extension HomeViewController {
    
    //MARK: - @objc Method
    
    func handleScrapTapped() {
        ToastManager.shared.show(
            message: "보관함에 추가했어요",
            actionText: "보러가기"
        ) { [weak self] in
            //self?.navigateToStorage()
        }
    }
}

extension HomeViewController {
    
    // MARK: - Method
    
    private func bind() {
        viewModel.$posts
            .sink { [weak self] _ in
                self?.editorCollectionView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Cell 앨범 커버 회전
    
    /// AudioPlayerManager를 구독하고 지금 화면에 보이는 MusicAlbumCell들을 전부 순회하면서, 각 셀이 가리키는 트랙 ID와
    /// 현재 재생 중인 오디오의 트랙 ID를 비교하여 맞으면 해당 cell의 앨범 커버를 회전 시킴
    private func bindAudioState() {
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
    
    private func loadData() {
        Task { await viewModel.loadHome() }
    }
}

private extension HomeViewController {
    
    // MARK: - Private Method
    
    func setupDelegate() {
        editorCollectionView.delegate = self
        editorCollectionView.dataSource = self
    }
    
    private func setupTarget() {
        musicScrapButton.addAction(
            UIAction { [weak self] _ in
                self?.handleScrapTapped()
            },
            for: .touchUpInside
        )
    }
}

// MARK: - UICollectionView

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = viewModel.posts.count
        return viewModel.isLocked ? count + 1 : count
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
             self?.viewModel.didTapPreview(post: post)
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
            albumCell.cellId == playingCellId &&
            AudioPlayerManager.shared.isPlaying

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

// MARK: - Popup Methods

extension HomeViewController {
    
    private func showLockedPopup() {
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
    
    private func hidePopup() {
        guard let popup = popupView else { return }

        UIView.animate(withDuration: 0.25, animations: {
            popup.alpha = 0
        }) { _ in
            popup.removeFromSuperview()
            self.popupView = nil
        }
    }
}
