//
//  ViewController.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 10/30/25.
//

import UIKit

import SnapKit
import Then

final class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - UI Properties
    
    private let navigationBarView = HomeNavigationBarView()
    private let todayDateLabel = UILabel()
    private let refreshButton = UIButton()
    
    private let questionContainerView = UIView()
    private let questionIamge = UIImageView()
    private let questionLabel = UILabel()
    private let questionTitleLabel = UILabel()
    
    private let musicStateButton = UIButton()
    private let editorCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupDelegate()
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
            $0.layer.cornerRadius = 12
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.gray200.cgColor
            $0.layer.cornerRadius = 12
        }
        
        questionIamge.do {
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
            $0.setTextStyle(.bodySemi14)
            $0.textColor = .black
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

            $0.configuration = config
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.dplay_pink.cgColor
        }
        
        editorCollectionView.do {
            let layout = UICollectionViewCompositionalLayout { section, env in
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .absolute(279),
                    heightDimension: .absolute(300)
                )
                
                let item = NSCollectionLayoutItem(layoutSize: itemSize)

                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .absolute(279),
                    heightDimension: .absolute(300)
                )
                
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: groupSize,
                    subitems: [item]
                )

                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPaging
                section.interGroupSpacing = 13
                section.contentInsets = NSDirectionalEdgeInsets(
                    top: 0,
                    leading: 48,
                    bottom: 0,
                    trailing: 48
                )

                return section
            }

            $0.setCollectionViewLayout(layout, animated: false)
            $0.register(MusicAlbumCell.self, forCellWithReuseIdentifier: MusicAlbumCell.identifier)
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
            questionIamge,
            questionLabel,
            questionTitleLabel
        )
    }
    
    func setupLayout() {
        navigationBarView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(48)
        }
        
        todayDateLabel.snp.makeConstraints {
            $0.top.equalTo(navigationBarView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(20)
        }
        
        refreshButton.snp.makeConstraints {
            $0.centerY.equalTo(todayDateLabel)
            $0.leading.equalTo(todayDateLabel.snp.trailing).offset(8)
            $0.size.equalTo(20)
        }
        
        questionContainerView.snp.makeConstraints {
            $0.top.equalTo(todayDateLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(66)
        }
        
        questionIamge.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.leading.equalToSuperview().inset(12)
            $0.size.equalTo(20)
        }
        
        questionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.leading.equalTo(questionIamge.snp.trailing).inset(4)
        }
        
        questionTitleLabel.snp.makeConstraints {
            $0.top.equalTo(questionIamge.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview().inset(12)
        }
        
        musicStateButton.snp.makeConstraints {
            $0.top.equalTo(questionContainerView.snp.bottom).offset(32)
            $0.leading.equalToSuperview().inset(136)
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

@objc private extension HomeViewController {
    //MARK: - @objc Method
}

extension HomeViewController {
    // MARK: - Method
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

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MusicAlbumCell.identifier,
            for: indexPath
        ) as? MusicAlbumCell else { return UICollectionViewCell() }
        return cell
    }
}

#if DEBUG
import SwiftUI

#Preview {
    HomeViewController()
}
#endif


