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
    private var results: [MusicAddResponseDTO] = []
    private var selectedIndex: IndexPath?
    
    // MARK: - UI Properties
    
    private let navigationBarView = MusicAddNavigationBarView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let searchTextField = UITextField()
    private let searchContainerView = UIView()
    private let tableView = UITableView()
    private let nextButton = UIButton()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupDelegate()
        setupTarget()
        bindNavigationBar()
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
            $0.font = .systemFont(ofSize: 22, weight: .bold)
            $0.textColor = .black
            $0.numberOfLines = 2
        }
        
        descriptionLabel.do {
            $0.text = ""
        }
        
        searchContainerView.do {
            $0.backgroundColor = .gray100
            $0.roundCorners(cornerRadius: 12)
        }
        
        searchTextField.do {
            $0.placeholder = "노래 제목이나 아티스트명을 검색해주세요"
            $0.font = .systemFont(ofSize: 16)
            $0.clearButtonMode = .whileEditing
        }
        
        tableView.do {
            $0.register(SongSearchCell.self, forCellReuseIdentifier: SongSearchCell.identifier)
            $0.isHidden = true
            $0.separatorStyle = .none
        }
        
        nextButton.do {
            $0.setTitle("다음으로", for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
            $0.backgroundColor = .gray300
            $0.isEnabled = false
            $0.layer.cornerRadius = 12
        }
    }
    
    func setupHierarchy() {
        view.addSubviews(
            navigationBarView,
            titleLabel,
            descriptionLabel,
            searchContainerView,
            tableView,
            nextButton
        )
        
        searchContainerView.addSubview(searchTextField)
    }
    
    func setupLayout() {
        
        navigationBarView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(44)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(navigationBarView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        searchContainerView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(48)
        }
        
        searchTextField.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(10)
            $0.horizontalEdges.equalToSuperview().inset(12)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(searchContainerView.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(nextButton.snp.top).offset(-16)
        }
        
        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(52)
        }
    }
}

@objc private extension MusicAddViewController {
    // MARK: - @objc Method
    func textFieldDidChange(_ textField: UITextField) {
        let text = textField.text ?? ""
        
        if text.isEmpty {
            tableView.isHidden = true
            results.removeAll()
            tableView.reloadData()
            updateNextButton()
        } else {
            tableView.isHidden = false
            mockSearch(text: text)
        }
    }
}

extension MusicAddViewController {
    private func bindNavigationBar() {
        navigationBarView.onTapBack = { [weak self] in
            self?.viewModel.didTapBack()
        }
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
        searchTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    func updateNextButton() {
        let enabled = (selectedIndex != nil)
        nextButton.isEnabled = enabled
        nextButton.backgroundColor = enabled ? .dplay_pink : .gray300
    }
    
    // ⭐ MOCK 검색 (API 붙이면 여기 수정)
    func mockSearch(text: String) {
        results = MusicAddMock.mockItems
        tableView.reloadData()
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
        let isSelected = selectedIndex == indexPath
        cell.configure(item: item, isSelected: isSelected)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath
        tableView.reloadData()
        updateNextButton()
    }
}

// MARK: - UITextField Delegate
extension MusicAddViewController: UITextFieldDelegate {}

