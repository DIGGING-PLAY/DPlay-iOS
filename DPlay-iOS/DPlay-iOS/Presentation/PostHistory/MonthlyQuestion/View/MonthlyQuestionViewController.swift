//
//  MonthlyQuestionViewController.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 12/31/25.
//

import Combine
import UIKit

import SnapKit
import Then

final class MonthlyQuestionViewController: UIViewController {
    
    //MARK: - Properties
    
    private let viewModel: MonthlyQuestionViewModel
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: - UI Properties

    private let navigationBarView = MonthlyQuestionNavigationBarView()
    private let questionsTableView = UITableView()
    private let emptyLabel = UILabel()

    //MARK: - Life Cycle
    
    init(viewModel: MonthlyQuestionViewModel) {
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

private extension MonthlyQuestionViewController {
    
    //MARK: - setup
    
    func setupStyle() {
        view.backgroundColor = .white
        
        questionsTableView.do {
            $0.register(QuestionsCell.self, forCellReuseIdentifier: QuestionsCell.className)
            $0.separatorStyle = .none
            $0.showsVerticalScrollIndicator = false
            $0.delegate = self
            $0.dataSource = self
        }
        
        emptyLabel.do {
            $0.text = "추천 기록이 없어요."
            $0.setTextStyle(.bodySemi14)
            $0.textColor = .gray400
            $0.textAlignment = .center
        }
    }
    
    func setupHierarchy() {
        view.addSubviews(
            navigationBarView,
            questionsTableView
        )
    }
    
    func setupLayout() {
        navigationBarView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(48)
        }
        
        questionsTableView.snp.makeConstraints {
            $0.top.equalTo(navigationBarView.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
        }
    }
}

private extension MonthlyQuestionViewController {
    
    // MARK: - Private Method
        
    func bindViewModel() {
        viewModel.$monthlyQuestions
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                
                questionsTableView.reloadData()
            }.store(in: &cancellables)
    }
    
    func bindNavigationBar() {
        navigationBarView.onTapBackButton = { [weak self] in
            guard let self else { return }
            
            viewModel.popToPrevious()
        }
        
        navigationBarView.onTapMonthSelectButton = { [weak self] in
            guard let self else { return }
            
            let modal = MonthPickerModalViewController(
                selectedYear: viewModel.selectedYear,
                selectedMonth: viewModel.selectedMonth,
                onTapSelectButton: { selectedYear, selectedMonth in
                    self.viewModel.selectedYear = selectedYear
                    self.viewModel.selectedMonth = selectedMonth
                    self.navigationBarView.setMonthButtonTitle(year: selectedYear, month: selectedMonth)
                    Task { await self.viewModel.loadMonthlyQuestions() }
                })
            
            if let sheet = modal.sheetPresentationController {
                sheet.detents = [
                    .custom { _ in 396 }
                ]
                sheet.prefersGrabberVisible = false
            }
            
            present(modal, animated: true)
        }
    }
    
    func loadData() {
        Task { await viewModel.loadMonthlyQuestions() }
    }
}

// MARK: - UITableView

extension MonthlyQuestionViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.monthlyQuestions?.count ?? 0
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: QuestionsCell.className,
                for: indexPath
            ) as? QuestionsCell
        else { return UITableViewCell() }
        
        if let questions = viewModel.monthlyQuestions {
            cell.configure(question: questions[indexPath.row])
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
