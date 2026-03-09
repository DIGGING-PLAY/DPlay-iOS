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

final class MusicSearchViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: MusicSearchViewModel
    private var cancellables = Set<AnyCancellable>()
    private var selectedIndex: IndexPath?

    // MARK: - UI Properties
    
    private let navigationBarView = MusicSearchNavigationBarView()
    private let titleLabel = UILabel()
    private let searchTextField = UITextField()
    private let clearButton = UIButton(type: .custom)
    private let tableView = UITableView()
    private let nextButton = UIButton()
    private let emptyBackgroundView = UIView()
    private let emptyResultLabel = UILabel()
    
    
    // MARK: - Life Cycle

    init(viewModel: MusicSearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupDelegate()
        setupTarget()
        bindNavigationBar()
        hideKeyboardWhenTappedAround()
    }
    
    required init?(coder: NSCoder) { fatalError() }
}


private extension MusicSearchViewController {
    
    func setupStyle() {
        view.backgroundColor = .white
        
        titleLabel.do {
            $0.text = "추천하고 싶은\n노래를 검색해보세요!"
            $0.textColor = .dplay_black
            $0.setTextStyle(.titleBold24)
            $0.numberOfLines = 2
        }
        
        searchTextField.do {
            $0.backgroundColor = .gray100
            $0.roundCorners(cornerRadius: 12)
            $0.tintColor = .dplay_pink
            $0.placeholder = "노래 제목이나 아티스트명을 검색해주세요"
            $0.setTextStyle(.bodySemi16)
            $0.returnKeyType = .search
            
            // 왼쪽 패딩
            $0.addPadding(left: 12)
            
            // 오른쪽 clear 버튼 영역
            let iconSize: CGFloat = 20
            let rightPadding: CGFloat = 16.5

            let rightViewWidth = iconSize + rightPadding
            let rightView = UIView(
                frame: CGRect(x: 0, y: 0, width: rightViewWidth, height: 53)
            )

            clearButton.frame = CGRect(
                x: 0,
                y: 0,
                width: iconSize,
                height: 53
            )

            rightView.addSubview(clearButton)

            searchTextField.rightView = rightView
            searchTextField.rightViewMode = .never
        }
        
        clearButton.do {
            $0.setImage(IconLiterals.ic_close_20, for: .normal)
            $0.tintColor = .gray400
        }
        
        tableView.do {
            $0.register(SongSearchCell.self, forCellReuseIdentifier: SongSearchCell.identifier)
            $0.isHidden = false
            $0.separatorStyle = .none
            $0.backgroundView = emptyBackgroundView
        }
        
        emptyResultLabel.do {
            $0.text = "일치하는 검색 결과가 없어요"
            $0.textColor = .gray400
            $0.textAlignment = .center
            $0.setTextStyle(.bodySemi14)
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
        emptyBackgroundView.addSubview(emptyResultLabel)
        
        view.addSubviews(
            navigationBarView,
            titleLabel,
            searchTextField,
            tableView,
            nextButton
        )
    }
    
    func setupLayout() {
        
        emptyResultLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        navigationBarView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(44)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(navigationBarView.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        searchTextField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(53)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(searchTextField.snp.bottom).offset(12)
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

private extension MusicSearchViewController {

    func bind() {
        viewModel.$tracks
            .combineLatest(viewModel.$hasSearched)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] tracks, hasSearched in
                guard let self else { return }
                
                self.tableView.isHidden = tracks.isEmpty && !hasSearched
                self.tableView.reloadData()

                let shouldShowEmpty =
                    hasSearched && tracks.isEmpty

                self.emptyResultLabel.isHidden = !shouldShowEmpty
            }
            .store(in: &cancellables)
    }
}

@objc private extension MusicSearchViewController {
    
    // MARK: - @objc Method
    
    func textDidChange(_ textField: UITextField) {
        // 기존 로직 유지
        selectedIndex = nil
        updateClearButtonVisibility()
        updateNextButton()

        // 한글 조합 중이면 검색하지 않음
        if textField.markedTextRange != nil { return }

        guard let query = textField.text, !query.isEmpty else {
            viewModel.cancelSearch()
            viewModel.clearResults()
            return
        }

        viewModel.searchWithDebounce(keyword: query)
    }
    
    func didTapClear() {
        searchTextField.text = ""
        selectedIndex = nil
        tableView.isHidden = true
        updateClearButtonVisibility()
        updateNextButton()
    }
    
    func didTapNext() {
        guard let index = selectedIndex else { return }
        let trackId = viewModel.tracks[index.row].id
        viewModel.didTapNext(trackId: trackId)
    }
}

private extension MusicSearchViewController {

    // MARK: - Setup

    func setupDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
        searchTextField.delegate = self
    }

    func setupTarget() {
        searchTextField.addTarget(
            self,
            action: #selector(textDidChange),
            for: .editingChanged
        )

        clearButton.addTarget(
            self,
            action: #selector(didTapClear),
            for: .touchUpInside
        )

        nextButton.addTarget(
            self,
            action: #selector(didTapNext),
            for: .touchUpInside
        )
    }
    
    // MARK: - NextButton 활성화 관련

    func updateNextButton() {
        let enabled = selectedIndex != nil
        nextButton.isEnabled = enabled
        nextButton.backgroundColor = enabled ? .dplay_pink : .gray200
        nextButton.setTitleColor(enabled ? .white : .gray400, for: .normal)
    }

    func updateClearButtonVisibility() {
        let hasText = !(searchTextField.text ?? "").isEmpty
        searchTextField.rightViewMode = hasText ? .always : .never
    }
}

// MARK: - Navigation

private extension MusicSearchViewController {
    func bindNavigationBar() {
        navigationBarView.onTapBack = { [weak self] in
            self?.viewModel.didTapBack()
        }
    }
}

// MARK: - UITableView Delegate

extension MusicSearchViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.tracks.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: SongSearchCell.identifier,
            for: indexPath
        ) as! SongSearchCell

        let track = viewModel.tracks[indexPath.row]
        
        cell.configure(
            item: track,
            isSelected: selectedIndex == indexPath
        )
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath
        updateNextButton()
        tableView.reloadData()
    }

    /// 셀 하나가 “화면에 나타나기 직전”에 호출
    /// viewModel에게 더 필요한지 여부를 전달, nextCursor 값 있으면 tracks 업데이트 됨
    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        Task {
            await viewModel.loadMoreIfNeeded(currentIndex: indexPath.row)
        }
    }
}

// MARK: - UITextField Delegate

extension MusicSearchViewController: UITextFieldDelegate {
    
    /// 키보드에서 Enter 입력시 호출
    /// 검색 이후 ViewModel tracks 업데이트
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let query = textField.text, !query.isEmpty else { return true }

        selectedIndex = nil
        updateNextButton()
        view.endEditing(true)

        Task {
            await viewModel.search(keyword: query)
        }

        return true
    }
}
