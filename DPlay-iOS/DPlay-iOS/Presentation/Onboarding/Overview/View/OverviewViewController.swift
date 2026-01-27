//
//  OverviewViewController.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 11/25/25.
//

import UIKit

import SnapKit
import Then

final class OverviewViewController: UIViewController {
    
    //MARK: - Properties
    
    private let viewModel: OverviewViewModel
    
    private let screenWidth = UIScreen.main.bounds.width
    private let titleTexts = [
        "오늘의 질문이 도착했어요",
        "다른 사람들의 추천을 만나보세요",
        "노래 추천 받으러 가볼까요?"
    ]
    private let descriptionTexts = [
        "모두가 같은 질문을 받고,\n그 순간에 어울리는 노래를 추천해요",
        "최대 3곡까지 먼저 보고\n노래를 추천하면 더 많은 추천을 볼 수 있어요",
        "마음에 드는 곡에 반응을 남기고,\n보관함에 추가할 수 있어요"
    ]
    private let onboardingImages: [UIImage] = [
        ImageLiterals.img_onboarding_1,
        ImageLiterals.img_onboarding_2,
        ImageLiterals.img_onboarding_3
    ]
    
    //MARK: - UI Properties

    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let pagingCollectioView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let pageControl = UIPageControl()
    private let startButton = UIButton()

    //MARK: - Life Cycle
    
    init(viewModel: OverviewViewModel) {
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
    }
}

private extension OverviewViewController {
    
    //MARK: - setup
    
    func setupStyle() {
        view.backgroundColor = .white
        
        titleLabel.do {
            $0.text = "오늘의 질문이 도착했어요"
            $0.setTextStyle(.titleBold24)
            $0.textColor = .dplay_black
            $0.textAlignment = .center
        }
        
        descriptionLabel.do {
            $0.text = "모두가 같은 질문을 받고,\n그 순간에 어울리는 노래를 추천해요"
            $0.setTextStyle(.bodyMedi16)
            $0.textColor = .gray400
            $0.numberOfLines = 2
            $0.textAlignment = .center
        }
        
        pagingCollectioView.do {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0

            $0.collectionViewLayout = layout
            $0.isPagingEnabled = true
            $0.showsHorizontalScrollIndicator = false
            $0.dataSource = self
            $0.delegate = self
            $0.register(OnboardingImageCell.self, forCellWithReuseIdentifier: OnboardingImageCell.className)
        }
        
        pageControl.do {
            $0.currentPage = 0
            $0.pageIndicatorTintColor = .gray200
            $0.currentPageIndicatorTintColor = .dplay_black
            $0.numberOfPages = 3
            $0.isUserInteractionEnabled = false
        }
        
        startButton.do {
            $0.setTitle("시작하기", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.setTextStyle(.bodyBold16)
            $0.backgroundColor = .dplay_pink
            $0.roundCorners(cornerRadius: 12)
        }
    }
    
    func setupHierarchy() {
        view.addSubviews(
            titleLabel,
            descriptionLabel,
            pagingCollectioView,
            pageControl,
            startButton
        )
    }
    
    func setupLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(88)
            $0.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
        }
        
        pagingCollectioView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(16)
            $0.size.equalTo(screenWidth)
        }
        
        pageControl.snp.makeConstraints {
            $0.top.equalTo(pagingCollectioView.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }

        startButton.snp.makeConstraints {
            $0.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.height.equalTo(61)
        }
    }
}

@objc private extension OverviewViewController {
    
    //MARK: - @objc Method
    
    func startButtonTapped() {
        viewModel.goToNotificationPermission()
    }
}

private extension OverviewViewController {
    
    // MARK: - Private Method
    
    func setupTarget() {
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
    }
}

extension OverviewViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return onboardingImages.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: OnboardingImageCell.className,
            for: indexPath
        ) as! OnboardingImageCell

        cell.configure(with: onboardingImages[indexPath.item])
        
        return cell
    }
}

extension OverviewViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
}

extension OverviewViewController: UIScrollViewDelegate {

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.frame.width)
        pageControl.currentPage = page
        titleLabel.text = titleTexts[page]
        descriptionLabel.text = descriptionTexts[page]
    }
}
