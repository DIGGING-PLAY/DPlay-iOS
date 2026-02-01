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
    private let musicsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: MyPageCollectionViewLayout.registeredMusicsLayout())
    private let emptyLabel = UILabel()

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
        
        emptyLabel.do {
            $0.text = "아직 등록한 곡이 없어요"
            $0.setTextStyle(.bodySemi14)
            $0.textColor = .gray400
            $0.textAlignment = .center
        }
        
        musicsCollectionView.do {
            $0.backgroundColor = .gray100
            $0.register(RegisteredMusicCell.self, forCellWithReuseIdentifier: RegisteredMusicCell.className)
            $0.register(ArchiveCell.self, forCellWithReuseIdentifier: ArchiveCell.className)
            $0.delegate = self
            $0.dataSource = self
            $0.backgroundView = emptyLabel
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
        let profileImage: UIImage?
        
        if viewModel.userProfileResult?.profile.user.profileImage == nil {
            profileImage = nil
        } else {
            profileImage = profileEditButton.getProfileUIImage()
        }
        
        viewModel.goToProfileEdit(profileImage: profileImage)
    }
}

private extension MyPageViewController {
    
    // MARK: - Private Method
    
    func setupTarget() {
        profileEditButton.addTarget(self, action: #selector(profileEditButtonTapped), for: .touchUpInside)
    }
    
    func bindViewModel() {
        viewModel.$userProfileResult
            .sink { [weak self] result in
                guard let self else { return }
                
                let nickname = result?.profile.user.nickname ?? ""
                let postCount = result?.profile.postTotalCount ?? Int()
                let profileImageUrl = result?.profile.user.profileImage ?? ""
                let isHost = result?.isHost ?? false
                
                nicknameLabel.text = nickname
                musicCountLabel.text = "총 \(postCount)개의 노래를 공유했어요"
                musicCountLabel.highlightText(targetText: "\(postCount)", color: .dplay_pink)
                profileEditButton.setProfileButton(isHost: isHost, profileImageUrl: profileImageUrl)
                navigationBarView.setNavigationBar(isHost: isHost)
            }
            .store(in: &cancellables)
        
        viewModel.$registeredMusics
            .sink { [weak self] result in
                guard let self else { return }
                
                if selectedTabIndex == 0 {
                    emptyLabel.isHidden = result.count != 0
                }
                musicsCollectionView.reloadData()
            }.store(in: &cancellables)
        
        viewModel.$archiveMusics
            .sink { [weak self] result in
                guard let self else { return }
                
                if selectedTabIndex == 1 {
                    emptyLabel.isHidden = result.count != 0
                }
                musicsCollectionView.reloadData()
            }.store(in: &cancellables)
    }
    
    func bindNavigationBar() {
        navigationBarView.onTapSettingButton = {
            self.viewModel.goToSetting()
        }
        
        navigationBarView.onTapBackButton = {
            self.viewModel.popToPrevious()
        }
    }
    
    func bindSegmentedControl() {
        segmentedControl.onTapRegisteredMusicsButton = {
            self.viewModel.resetCursor()
            if self.selectedTabIndex == 1 {
                self.selectedTabIndex = 0
                self.musicsCollectionView.setCollectionViewLayout(
                    MyPageCollectionViewLayout.registeredMusicsLayout(),
                    animated: false
                ) { _ in
                    self.emptyLabel.text = "아직 등록한 곡이 없어요"
                    self.musicsCollectionView.reloadData()
                    self.musicsCollectionView.setContentOffset(.zero, animated: false)
                    self.musicsCollectionView.layoutIfNeeded()
                    
                    self.emptyLabel.isHidden = self.viewModel.registeredMusics.count != 0
                }
            }
        }
        
        segmentedControl.onTapArchiveButton = {
            self.viewModel.resetCursor()
            if self.selectedTabIndex == 0 {
                self.selectedTabIndex = 1
                self.musicsCollectionView.setCollectionViewLayout(
                    MyPageCollectionViewLayout.archiveLayout(),
                    animated: false
                ) { _ in
                    if self.viewModel.archiveMusics.isEmpty {
                        self.emptyLabel.text = "아직 저장한 곡이 없어요"
                        Task { await self.viewModel.loadArchiveMusics() }
                    } else {
                        self.musicsCollectionView.reloadData()
                        self.musicsCollectionView.setContentOffset(.zero, animated: false)
                        self.musicsCollectionView.layoutIfNeeded()
                        
                        self.emptyLabel.isHidden = self.viewModel.archiveMusics.count != 0
                    }
                }
            }
        }
    }
    
    func loadData() {
        Task { await viewModel.loadUserProfile() }
        Task { await viewModel.loadRegisteredMusics() }
    }
    
    func showDeleteModal(postId: Int) {
        let modal = DPlayButtonModalViewController(
            type: .warning,
            primaryButtonTitle: "삭제하기",
            secondaryButtonTitle: "취소하기",
            primaryAction: {
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
                                Task { await self.viewModel.deletePost(postId: postId) }
                            })
                    ],
                )
            },
            secondaryAction: {
                print("취소하기 탭")
            }
        )
        
        if let sheet = modal.sheetPresentationController {
            sheet.detents = [
                .custom { _ in 110 }
            ]
            sheet.prefersGrabberVisible = false
        }

        present(modal, animated: true)
    }
}

// MARK: - UICollectionView

extension MyPageViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if selectedTabIndex == 0 {
            return viewModel.registeredMusics.count
        } else {
            return viewModel.archiveMusics.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if selectedTabIndex == 0 {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RegisteredMusicCell.className,
                for: indexPath
            ) as? RegisteredMusicCell else { return UICollectionViewCell() }
            
            if let isHost = viewModel.isHost {
                cell.configureCell(isHost: isHost, with: viewModel.registeredMusics[indexPath.item])
                
                if isHost {
                    cell.onTapMoreButton = { [weak self] in
                        guard let self else { return }
                        
                        showDeleteModal(postId: viewModel.registeredMusics[indexPath.item].id)
                    }
                }
            }
            
            
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ArchiveCell.className,
                for: indexPath
            ) as? ArchiveCell else { return UICollectionViewCell() }
            
            cell.configureCell(with: viewModel.archiveMusics[indexPath.item])
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let postId: Int
        
        if selectedTabIndex == 0 {
            postId = viewModel.registeredMusics[indexPath.item].id
        } else {
            postId = viewModel.archiveMusics[indexPath.item].id
        }
        
        viewModel.goToMusicDetail(trackId: String(postId))
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if selectedTabIndex == 0 {
            Task { await viewModel.loadRegisteredMusicsMore(currentIndex: indexPath.item) }
        } else {
            if indexPath.item % 3 == 0 {
                Task { await viewModel.loadArchiveMusicsMore(currentIndex: indexPath.item) }
            }
        }
    }
}
