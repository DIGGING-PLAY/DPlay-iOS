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

    // MARK: - UI Properties
    
    private let navigationBarView = HomeNavigationBarView()
    private let todayDateLabel = UILabel()
    private let refreshButton = UIButton()
    
    private let questionContainerView = UIView()
    private let questionImage = UIImageView()
    private let questionLabel = UILabel()
    private let questionTitleLabel = UILabel()
    
    private let musicStateButton = UIButton()
    private let editorCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    
    // MARK: - Life Cycle
    
    init(viewModel: HomeViewModel) {
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
        setupDelegate()
        bind()
    }
}

private extension HomeViewController {
    
    // MARK: - Layout
    
    func setupStyle() {
        view.backgroundColor = .white
        
        todayDateLabel.do {
            $0.text = "10월 12일의 발견"
            $0.setTextStyle(.titleBold18)
            $0.textColor = .black
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
            $0.textColor = .black
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
        
        editorCollectionView.do {
            $0.backgroundColor = .clear
            $0.setCollectionViewLayout(makeEditorLayout(), animated: false)
            $0.register(MusicAlbumCell.self, forCellWithReuseIdentifier: MusicAlbumCell.identifier)
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
            editorCollectionView
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

            return section
        }
    }
}


@objc private extension HomeViewController {
    //MARK: - @objc Method
}

extension HomeViewController {
    
    // MARK: - Method
    
    private func bind() {
        viewModel.$posts.sink { [weak self] _ in
            self?.editorCollectionView.reloadData()
        }.store(in: &cancellables)
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
    
    func setupTarget() {
        //addTarget
    }
}

// MARK: - UICollectionView

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MusicAlbumCell.identifier,
            for: indexPath
        ) as? MusicAlbumCell else { return UICollectionViewCell() }
        let post = viewModel.posts[indexPath.row]
        cell.configure(with: post)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let post = viewModel.posts[indexPath.item]
        viewModel.didSelectPost(post)
    }
}
