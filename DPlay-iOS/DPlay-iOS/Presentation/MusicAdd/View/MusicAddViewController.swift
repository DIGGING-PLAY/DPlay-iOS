//
//  MusicAddViewController.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 11/24/25.
//

import UIKit
import Combine

import SnapKit
import Then

final class MusicAddViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: MusicAddViewModel
    
    private var cancellables = Set<AnyCancellable>()
    private var results: [MusicAddResponseDTO] = [] // 추후 엔티티로 수정 예정
    private var selectedIndex: IndexPath?
    private var committedQuery: String?
    
    // MARK: - UI Properties
    
    private let navigationBarView = MusicAddNavigationBarView()
    private let titleLabel = UILabel()
    private let searchTextField = UITextField()
    private let rightButton = UIButton(type: .custom)
    private let searchContainerView = UIView()
    private let searchButton = UIButton(type: .custom)
    private let clearButton = UIButton(type: .custom)
    private let tableView = UITableView()
    private let nextButton = UIButton()
    
    private let emptyResultLabel = UILabel()
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupDelegate()
        setupTarget()
        bindNavigationBar()
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    init(viewModel: MusicAddViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
}

private extension MusicAddViewController {
    
    // MARK: - Layout
    
    func setupStyle() {
        view.backgroundColor = .white
        
        titleLabel.do {
            $0.text = "추천하고 싶은\n노래를 검색해보세요!"
            $0.setTextStyle(.titleBold24)
            $0.textColor = .black
            $0.numberOfLines = 2
        }
        
        searchContainerView.do {
            $0.backgroundColor = .gray100
            $0.roundCorners(cornerRadius: 12)
        }
        
        searchTextField.do {
            $0.placeholder = "노래 제목이나 아티스트명을 검색해주세요"
            $0.setTextStyle(.bodySemi16)
            $0.clearButtonMode = .never
            $0.tintColor = .dplay_pink
        }
        
        searchButton.do {
            $0.setImage(IconLiterals.ic_search_20, for: .normal)
            $0.tintColor = .gray400
        }
        
        clearButton.do {
            $0.setImage(IconLiterals.ic_close_20, for: .normal)
            $0.tintColor = .gray400
            //$0.isHidden = true
        }
        
        tableView.do {
            $0.register(SongSearchCell.self, forCellReuseIdentifier: SongSearchCell.identifier)
            $0.isHidden = true
            $0.separatorStyle = .none
            $0.backgroundView = emptyResultLabel
        }
        
        emptyResultLabel.do {
            $0.text = "일치하는 검색 결과가 없어요"
            $0.setTextStyle(.bodySemi14)
            $0.textColor = .gray400
            $0.textAlignment = .center
            $0.isHidden = true
        }
        
        nextButton.do {
            $0.setTitle("다음으로", for: .normal)
            $0.titleLabel?.setTextStyle(.bodyBold16)
            $0.setTitleColor(.gray400, for: .normal)
            $0.backgroundColor = .gray200
            $0.isEnabled = false
            $0.roundCorners(cornerRadius: 12)
        }
    }
    
    func setupHierarchy() {
        view.addSubviews(
            navigationBarView,
            titleLabel,
            searchContainerView,
            tableView,
            nextButton
        )

        searchContainerView.addSubviews(
            searchTextField,
            searchButton,
            clearButton
        )
    }
    
    func setupLayout() {
        
        navigationBarView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(44)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(navigationBarView.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        searchContainerView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(53)
        }
        
        searchTextField.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(16)
            $0.horizontalEdges.equalToSuperview().inset(12)
        }
        
        searchButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }
        
        clearButton.snp.makeConstraints {
            //$0.edges.equalTo(searchButton)
            $0.trailing.equalToSuperview().inset(32)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(searchContainerView.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(nextButton.snp.top).offset(-12)
        }
        
        nextButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.height.equalTo(61)
        }
    }
}

@objc private extension MusicAddViewController {
    
    // MARK: - @objc Method
    
    func textDidChange() {
        //updateRightButtons()
        committedQuery = nil
        selectedIndex = nil
        updateNextButton()
    }

    func didTapSearch() {
        guard let query = searchTextField.text, !query.isEmpty else { return }
        committedQuery = query
        selectedIndex = nil

        mockSearch(text: query)
        updateEmptyView()
        tableView.isHidden = false
        updateNextButton()
        view.endEditing(true)
    }

    func didTapClear() {
        searchTextField.text = ""
        committedQuery = nil
        selectedIndex = nil
        updateRightButtons()
        updateNextButton()
    }

    func didTapNext() {
        guard let index = selectedIndex else { return }
        let trackId = results[index.row].trackId
        viewModel.didTapNext(trackId: trackId)
    }
}

private extension MusicAddViewController {
    
    // MARK: - Private Method
    
    func setupDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
        searchTextField.delegate = self
    }
    
    func setupTarget() {
        searchTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        searchButton.addTarget(self, action: #selector(didTapSearch), for: .touchUpInside)
        clearButton.addTarget(self, action: #selector(didTapClear), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
    }
    
    func updateNextButton() {
        let enabled =
            committedQuery != nil &&
            selectedIndex != nil

        nextButton.isEnabled = enabled
        nextButton.backgroundColor = enabled ? .dplay_pink : .gray200
        nextButton.setTitleColor(enabled ? .white : .gray400, for: .normal)
    }
    
    func updateRightButtons() {
        let hasText = !(searchTextField.text ?? "").isEmpty
        searchButton.isHidden = hasText
        clearButton.isHidden = !hasText
    }
    
    // ⭐ MOCK 검색 (API 붙이면 여기 수정)
    func mockSearch(text: String) {
        results = MusicAddMock.mockItems
        tableView.reloadData()
    }
    
    func updateEmptyView() {
        let shouldShowEmpty =
            committedQuery != nil &&
            results.isEmpty

        tableView.backgroundView?.isHidden = !shouldShowEmpty
    }
}

// MARK: - Navigation

private extension MusicAddViewController {
    func bindNavigationBar() {
        navigationBarView.onTapBack = { [weak self] in
            self?.viewModel.didTapBack()
        }
    }
}

// MARK: - UITableView Delegate

extension MusicAddViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: SongSearchCell.identifier, for: indexPath) as? SongSearchCell
        else { return UITableViewCell() }
        
        let item = results[indexPath.row]
        cell.configure(item: item, isSelected: selectedIndex == indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath
        updateNextButton()
        tableView.reloadData()
    }
}

// MARK: - UITextField Delegate

extension MusicAddViewController: UITextFieldDelegate {}

