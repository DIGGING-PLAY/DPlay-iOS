//
//  QuestionPostsViewController.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 12/31/25.
//

import Combine
import UIKit

import SnapKit
import Then

final class QuestionPostsViewController: UIViewController {
    
    //MARK: - Properties
    
    private let viewModel: QuestionPostsViewModel
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: - UI Properties

    private let navigationBarView = QuestionPostsNavigationBarView()
    private let questionContainerView = UIView()
    private let questionImage = UIImageView()
    private let questionLabel = UILabel()
    private let questionTitleLabel = UILabel()
    private let totalCountLabel = UILabel()
    private let postsTableView = UITableView()
    private let backgroundColorView = UIView()
    private let emptyLabel = UILabel()

    //MARK: - Life Cycle
    
    init(viewModel: QuestionPostsViewModel) {
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
                
        bindViewModel()
        bindNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
     
        loadData()
    }
}

private extension QuestionPostsViewController {
    
    //MARK: - setup
    
    func setupStyle() {
        view.backgroundColor = .white

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
            $0.text = "이 날의 질문"
            $0.textColor = .dplay_pink
            $0.setTextStyle(.bodySemi14)
        }
        
        questionTitleLabel.do {
            $0.text = " "
            $0.textColor = .dplay_black
            $0.setTextStyle(.bodySemi14)
        }
        
        totalCountLabel.do {
            $0.text = " "
            $0.textColor = .gray500
            $0.setTextStyle(.capMedi12)
        }

        postsTableView.do {
            $0.backgroundColor = .clear
            $0.register(QuestionPostCell.self, forCellReuseIdentifier: QuestionPostCell.className)
            $0.separatorStyle = .none
            $0.showsVerticalScrollIndicator = false
            $0.delegate = self
            $0.dataSource = self
        }
        
        backgroundColorView.do {
            $0.backgroundColor = .gray100
        }
    }
    
    func setupHierarchy() {
        view.addSubviews(
            navigationBarView,
            questionContainerView,
            totalCountLabel,
            backgroundColorView,
        )
        
        backgroundColorView.addSubview(postsTableView)
        
        questionContainerView.addSubviews(
            questionImage,
            questionLabel,
            questionTitleLabel
        )
    }
    
    func setupLayout() {
        navigationBarView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(48)
        }
        
        questionContainerView.snp.makeConstraints {
            $0.top.equalTo(navigationBarView.snp.bottom).offset(12)
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
        
        totalCountLabel.snp.makeConstraints {
            $0.top.equalTo(questionContainerView.snp.bottom).offset(12)
            $0.leading.equalToSuperview().inset(16)
        }
        
        backgroundColorView.snp.makeConstraints {
            $0.top.equalTo(totalCountLabel.snp.bottom).offset(12)
            $0.horizontalEdges.bottom.equalToSuperview()
        }

        postsTableView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
        }
    }
}

private extension QuestionPostsViewController {
    
    // MARK: - Private Method
        
    func bindViewModel() {
        viewModel.$sample
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                guard let self, let data else { return }
                
                navigationBarView.setDateTitle(data.date)
                questionTitleLabel.text = data.title
                totalCountLabel.text = "총 \(data.totalCount)개의 곡"
                postsTableView.reloadData()
            }.store(in: &cancellables)
    }
    
    func bindNavigationBar() {
        navigationBarView.onTapBackButton = { [weak self] in
            guard let self else { return }
            
            viewModel.popToPrevious()
        }
    }
    
    func loadData() {
        Task { await viewModel.loadQuestionPosts() }
    }
}

// MARK: - UITableView

extension QuestionPostsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sample?.items.count ?? 0
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
                withIdentifier: QuestionPostCell.className,
                for: indexPath
        ) as? QuestionPostCell, let data = viewModel.sample
        else { return UITableViewCell() }
        
        cell.configureCell(post: data.items[indexPath.row])

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
