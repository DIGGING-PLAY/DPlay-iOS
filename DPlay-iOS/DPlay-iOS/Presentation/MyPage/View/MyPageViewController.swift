//
//  MyPageViewController.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 11/27/25.
//

import UIKit
import Combine

import SnapKit
import Then

final class MyPageViewController: UIViewController {
    
    //MARK: - Properties
    
    private let viewModel: MyPageViewModel
    private var cancellables = Set<AnyCancellable>()

    private var selectedTabIndex = 0
    
    //MARK: - UI Properties

    private let navigationBarView = MyPageNavigationBarView()
    private let nicknameLabel = UILabel()
    private let musicCountLabel = UILabel()
    private let labelStackView = UIStackView()
    private let profileEditButton = ProfileEditButton()
    private let segmentedControl = MyPageSegmentedControl()
    private let musicsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: MyPageCollectionViewLayoutFactory.registeredMusicsLayout())

    //MARK: - Life Cycle
    
    init(viewModel: MyPageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        
        setupTarget()
        
        bindViewModel()
        bindNavigationBar()
        bindSegmentedControl()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
     
        loadData()
    }
}

private extension MyPageViewController {
    
    //MARK: - setup
    
    func setupStyle() {
        view.backgroundColor = .white
        
        nicknameLabel.do {
            $0.text = " "
            $0.setTextStyle(.titleBold24)
            $0.textColor = .dplay_black
            $0.textAlignment = .left
        }
        
        musicCountLabel.do {
            $0.text = " "
            $0.setTextStyle(.bodySemi14)
            $0.textColor = .gray400
            $0.textAlignment = .left
        }
        
        labelStackView.do {
            $0.axis = .vertical
            $0.spacing = 4
        }
        
        musicsCollectionView.do {
            $0.backgroundColor = .gray100
            $0.showsVerticalScrollIndicator = false
            $0.register(RegisteredMusicCell.self, forCellWithReuseIdentifier: RegisteredMusicCell.className)
            $0.register(ArchiveCell.self, forCellWithReuseIdentifier: ArchiveCell.className)
            $0.delegate = self
            $0.dataSource = self
        }
    }
    
    func setupHierarchy() {
        view.addSubviews(
            navigationBarView,
            profileEditButton,
            labelStackView,
            segmentedControl,
            musicsCollectionView
        )
        
        labelStackView.addArrangedSubviews(nicknameLabel, musicCountLabel)
    }
    
    func setupLayout() {
        navigationBarView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(48)
        }
        
        profileEditButton.snp.makeConstraints {
            $0.top.equalTo(navigationBarView.snp.bottom).offset(12)
            $0.trailing.equalToSuperview().inset(16)
            $0.size.equalTo(80)
        }
        
        labelStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalTo(profileEditButton.snp.centerY)
        }
        
        segmentedControl.snp.makeConstraints {
            $0.top.equalTo(profileEditButton.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(45)
        }
        
        musicsCollectionView.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

@objc private extension MyPageViewController {
    
    //MARK: - @objc Method
        
    func profileEditButtonTapped() {
        print("profileEditButtonTapped")
    }
}

private extension MyPageViewController {
    
    // MARK: - Private Method
    
    func setupTarget() {
        profileEditButton.addTarget(self, action: #selector(profileEditButtonTapped), for: .touchUpInside)
    }
    
    func bindViewModel() {
        viewModel.$userProfile
            .sink { [weak self] profile in
                guard let self else { return }
                
                let nickname = profile?.user.nickname ?? ""
                let postCount = profile?.postTotalCount ?? Int()
                let profileImageUrl = profile?.user.profileImage ?? ""
                let isHost = profile?.isHost ?? false
                
                nicknameLabel.text = nickname
                musicCountLabel.text = "총 \(postCount)개의 노래를 공유했어요"
                musicCountLabel.highlightText(targetText: "\(postCount)", color: .dplay_pink)
                profileEditButton.setProfileButton(isHost: isHost, profileImageUrl: profileImageUrl)
                navigationBarView.setNavigationBar(isHost: isHost)
            }
            .store(in: &cancellables)
        
        viewModel.$registeredMusics
            .sink { [weak self] _ in
                guard let self else { return }
                
                musicsCollectionView.reloadData()
            }.store(in: &cancellables)
        
        viewModel.$archiveMusics
            .sink { [weak self] _ in
                guard let self else { return }
                
                musicsCollectionView.reloadData()
            }.store(in: &cancellables)
    }
    
    func bindNavigationBar() {
        navigationBarView.onTapSettingButton = {
            print("settingButtonTapped")
        }
        
        navigationBarView.onTapBackButton = {
            print("backButtonTapped")
        }
    }
    
    func bindSegmentedControl() {
        segmentedControl.onTapRegisteredMusicsButton = {
            if self.selectedTabIndex == 1 {
                self.selectedTabIndex = 0
                self.musicsCollectionView.setCollectionViewLayout(
                    MyPageCollectionViewLayoutFactory.registeredMusicsLayout(),
                    animated: false
                ) { _ in
                    self.musicsCollectionView.reloadData()
                    self.musicsCollectionView.setContentOffset(.zero, animated: false)
                    self.musicsCollectionView.layoutIfNeeded()
                }
            }
        }
        
        segmentedControl.onTapArchiveButton = {
            if self.selectedTabIndex == 0 {
                self.selectedTabIndex = 1
                self.musicsCollectionView.setCollectionViewLayout(
                    MyPageCollectionViewLayoutFactory.archiveLayout(),
                    animated: false
                ) { _ in
                    guard (self.viewModel.archiveMusics != nil) else {
                        Task { await self.viewModel.loadArchiveMusics() }
                        return
                    }
                    self.musicsCollectionView.reloadData()
                    self.musicsCollectionView.setContentOffset(.zero, animated: false)
                    self.musicsCollectionView.layoutIfNeeded()
                }
            }
        }
    }
    
    func loadData() {
        Task { await viewModel.loadUserProfile() }
        Task { await viewModel.loadRegisteredMusics() }
    }
}

// MARK: - UICollectionView

extension MyPageViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if selectedTabIndex == 0 {
            return viewModel.registeredMusics?.totalCount ?? 0
        } else {
            return viewModel.archiveMusics?.totalCount ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if selectedTabIndex == 0 {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RegisteredMusicCell.className,
                for: indexPath
            ) as? RegisteredMusicCell else { return UICollectionViewCell() }
            
            if let data = viewModel.registeredMusics, let isHost = data.isHost {
                cell.configureCell(isHost: isHost, with: data.items[indexPath.item])
            }
            
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ArchiveCell.className,
                for: indexPath
            ) as? ArchiveCell else { return UICollectionViewCell() }
            
            if let models = viewModel.archiveMusics?.items {
                cell.configureCell(with: models[indexPath.item])
            }
            
            return cell
        }
    }
}
