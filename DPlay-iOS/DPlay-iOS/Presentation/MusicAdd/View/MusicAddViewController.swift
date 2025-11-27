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
    private let searchTextField = UITextField()
    private let rightButton = UIButton(type: .custom)
    private let searchContainerView = UIView()
    private let tableView = UITableView()
    private let nextButton = UIButton()
    
    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupDelegate()
        setupTarget()
        setupRightButton()
        bindNavigationBar()
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
        }
        
        tableView.do {
            $0.register(SongSearchCell.self, forCellReuseIdentifier: SongSearchCell.identifier)
            $0.isHidden = true
            $0.separatorStyle = .none
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
    
    func textFieldDidChange(_ textField: UITextField) {
        let text = textField.text ?? ""

        // 입력 중에는 항상 검색 아이콘 보이기
        setSearchIcon()

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

    func didTapNext() {
        guard let index = selectedIndex else { return }
        
        let selectedTrack = results[index.row]
        let trackId = selectedTrack.trackId
        viewModel.didTapNext(trackId: trackId)
    }
    
    /// 버튼의 따른 액션 정의
    func didTapRightButton() {
        if rightButton.currentImage == IconLiterals.ic_close_20 {
            // X 버튼 → 텍스트 클리어
            searchTextField.text = ""
            setSearchIcon()
            searchTextField.sendActions(for: .editingChanged)
            return
        }
        
        // 돋보기 → 검색 기능 실행
        let query = searchTextField.text ?? ""
        mockSearch(text: query)
    }
    
    private func keyboardWillHide() {
        setClearIcon()
    }
}

extension MusicAddViewController {
    private func bindNavigationBar() {
        navigationBarView.onTapBack = { [weak self] in
            self?.viewModel.didTapBack()
        }
    }
    
    /// 기본은 돋보기 아이콘 키보드가 내려가면 close 아이콘
    private func setupRightButton() {
        rightButton.tintColor = .gray400
        rightButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        rightButton.addTarget(self, action: #selector(didTapRightButton), for: .touchUpInside)
        searchTextField.setRightButton(rightButton)
        setSearchIcon()
    }
    
    private func setSearchIcon() {
        rightButton.setImage(IconLiterals.ic_search_20, for: .normal)
    }

    private func setClearIcon() {
        rightButton.setImage(IconLiterals.ic_close_20, for: .normal)
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
        nextButton.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
    }
    
    func updateNextButton() {
        let enabled = (selectedIndex != nil)
        nextButton.isEnabled = enabled
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.backgroundColor = enabled ? .dplay_pink : .gray400
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
        updateNextButton()
        tableView.reloadData()
        searchTextField.resignFirstResponder()
        setClearIcon()
    }
}

// MARK: - UITextField Delegate
extension MusicAddViewController: UITextFieldDelegate {}

