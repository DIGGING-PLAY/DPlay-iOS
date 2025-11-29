//
//  MypageViewController.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 11/27/25.
//

import UIKit

import SnapKit
import Then

final class MypageViewController: UIViewController {
    
    //MARK: - Properties
    
//    private let viewModel: MypageViewModel
    
    private var selectedTabIndex = 0
    
    //MARK: - UI Properties

    private let navigationBarView = MypageNavigationBarView()
    private let nicknameLabel = UILabel()
    private let musicCountLabel = UILabel()
    private let labelStackView = UIStackView()
    private let profileEditButton = ProfileEditButton()
    private let segmentedControl = MypageSegmentedControl()
    private let musicsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: MypageCollectionViewLayoutFactory.registeredMusicsLayout())

    //MARK: - Life Cycle
    
//    init(viewModel: MypageViewModel) {
//        self.viewModel = viewModel
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        
        setupTarget()
        
        bindNavigationBar()
        bindSegmentedControl()
    }
}

private extension MypageViewController {
    
    //MARK: - setup
    
    func setupStyle() {
        view.backgroundColor = .white
        
        nicknameLabel.do {
            $0.text = "디플레이"
            $0.setTextStyle(.titleBold24)
            $0.textColor = .dplay_black
            $0.textAlignment = .left
        }
        
        musicCountLabel.do {
            $0.text = "총 16개의 노래를 공유했어요"
            $0.setTextStyle(.bodySemi14)
            $0.textColor = .gray400
            $0.highlightText(targetText: "16", color: .dplay_pink)
            $0.textAlignment = .left
        }
        
        labelStackView.do {
            $0.axis = .vertical
            $0.spacing = 4
        }
        
        musicsCollectionView.do {
            $0.backgroundColor = .gray100
            $0.showsVerticalScrollIndicator = false
            $0.register(RegisteredMusicCell.self, forCellWithReuseIdentifier: RegisteredMusicCell.identifier)
            $0.register(ArchiveCell.self, forCellWithReuseIdentifier: ArchiveCell.identifier)
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

@objc private extension MypageViewController {
    
    //MARK: - @objc Method
        
    func profileEditButtonTapped() {
        print("profileEditButtonTapped")
    }
}

private extension MypageViewController {
    
    // MARK: - Private Method
    
    func setupTarget() {
        profileEditButton.addTarget(self, action: #selector(profileEditButtonTapped), for: .touchUpInside)
    }
    
    func bindNavigationBar() {
        navigationBarView.onTapSettingButton = {
            print("SettingButtonTapped")
        }
    }
    
    func bindSegmentedControl() {
        segmentedControl.onTapRegisteredMusicsButton = {
            if self.selectedTabIndex == 1 {
                self.selectedTabIndex = 0
                self.musicsCollectionView.setCollectionViewLayout(
                    MypageCollectionViewLayoutFactory.registeredMusicsLayout(),
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
                    MypageCollectionViewLayoutFactory.archiveLayout(),
                    animated: false
                ) { _ in
                    self.musicsCollectionView.reloadData()
                    self.musicsCollectionView.setContentOffset(.zero, animated: false)
                    self.musicsCollectionView.layoutIfNeeded()
                }
            }
        }
    }
}

// MARK: - UICollectionView

extension MypageViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if selectedTabIndex == 0 {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RegisteredMusicCell.identifier,
                for: indexPath
            ) as? RegisteredMusicCell else { return UICollectionViewCell() }
            
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ArchiveCell.identifier,
                for: indexPath
            ) as? ArchiveCell else { return UICollectionViewCell() }
            
            return cell
        }
    }
}

#if DEBUG
import SwiftUI

#Preview {
    MypageViewController()
}
#endif
