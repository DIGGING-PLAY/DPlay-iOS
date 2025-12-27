//
//  MusicCommentViewController.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 11/25/25.
//

import UIKit
import Combine

import SnapKit
import Then

final class MusicCommentViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: MusicCommentViewModel
    private var cancellables = Set<AnyCancellable>()
    private let maxCount = 150
    
    // MARK: - UI Properties
    
    private let navigationBarView = MusicCommentNavigationBarView()
    
    private let titleLabel = UILabel()
    private let coverImageView = UIImageView()
    private let songTitleLabel = UILabel()
    private let artistLabel = UILabel()
    
    private let textViewContainer = UIView()
    private let textView = UITextView()
    private let placeholderLabel = UILabel()
    private let countLabel = UILabel()
    
    private let guideButton = UIButton()
    private var popupView: CommentGuidePopupView?
    private let registerButton = UIButton()

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupDelegate()
        setupTarget()
    }
    
    init(viewModel: MusicCommentViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
}

private extension MusicCommentViewController {
    
    // MARK: - Style
    
    func setupStyle() {
        view.backgroundColor = .white
        
        titleLabel.do {
            $0.text = "노래에 대한\n이야기를 작성해보세요!"
            $0.setTextStyle(.titleBold24)
            $0.numberOfLines = 2
            $0.textColor = .black
        }
        
        coverImageView.do {
            $0.backgroundColor = .gray200
            $0.layer.borderWidth = 2
            $0.layer.borderColor = UIColor.gray200.cgColor
            $0.roundCorners(cornerRadius: 66)
            $0.contentMode = .scaleAspectFill
        }
        
        songTitleLabel.do {
            $0.text = "내일에서 온 티켓"
            $0.setTextStyle(.titleBold18)
            $0.textColor = .black
            $0.textAlignment = .center
        }
        
        artistLabel.do {
            $0.text = "한로로"
            $0.setTextStyle(.bodySemi14)
            $0.textColor = .gray400
            $0.textAlignment = .center
        }
        
        textViewContainer.do {
            $0.backgroundColor = .gray100
            $0.roundCorners(cornerRadius: 12)
            $0.tintColor = .dplay_pink
        }
        
        textView.do {
            $0.backgroundColor = .clear
            $0.textColor = .black
        }
        
        placeholderLabel.do {
            $0.text = "노래에 대한 이야기를 자유롭게 작성해주세요."
            $0.setTextStyle(.bodySemi14)
            $0.textColor = .gray400
        }
        
        countLabel.do {
            $0.text = "0/150"
            $0.setTextStyle(.capMedi12)
            $0.textColor = .gray400
            $0.textAlignment = .right
        }
        
        guideButton.do {
            var config = UIButton.Configuration.plain()
            
            config.image = IconLiterals.ic_info_20
            config.imagePlacement = .leading
            config.imagePadding = 4

            config.contentInsets = NSDirectionalEdgeInsets(
                top: 8,
                leading: 8,
                bottom: 8,
                trailing: 8
            )
            
            var titleAttr = AttributedString("커뮤니티 가이드")
            titleAttr.font = UIFont.dplayFont(.capMedi12)
            titleAttr.foregroundColor = .gray400
            config.attributedTitle = titleAttr
            $0.configuration = config

            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.gray200.cgColor
            $0.roundCorners(cornerRadius: 20)
        }
        
        registerButton.do {
            $0.setTitle("등록하기", for: .normal)
            $0.titleLabel?.setTextStyle(.bodyBold16)
            $0.setTitleColor(.gray400, for: .normal)
            $0.backgroundColor = .gray200
            $0.isEnabled = false
            $0.roundCorners(cornerRadius: 12)
        }
    }
    
    // MARK: - Hierarchy
    
    func setupHierarchy() {
        view.addSubviews(
            navigationBarView,
            titleLabel,
            coverImageView,
            songTitleLabel,
            artistLabel,
            textViewContainer,
            guideButton,
            registerButton
        )
        
        textViewContainer.addSubviews(textView, placeholderLabel, countLabel)
    }
    
    // MARK: - Layout
    
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
        
        coverImageView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(32)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(132)
        }
        
        songTitleLabel.snp.makeConstraints {
            $0.top.equalTo(coverImageView.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
        }
        
        artistLabel.snp.makeConstraints {
            $0.top.equalTo(songTitleLabel.snp.bottom).offset(6)
            $0.centerX.equalToSuperview()
        }
        
        textViewContainer.snp.makeConstraints {
            $0.top.equalTo(artistLabel.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(180)
        }
        
        textView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.horizontalEdges.equalToSuperview().inset(12)
            $0.height.equalTo(130)
        }
        
        placeholderLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().inset(16)
        }
        
        countLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview().inset(16)
        }
        
        guideButton.snp.makeConstraints {
            $0.top.equalTo(textViewContainer.snp.bottom).offset(12)
            $0.leading.equalToSuperview().inset(16)
            $0.height.equalTo(36)
            $0.width.equalTo(127)
        }
        
        registerButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.height.equalTo(61)
        }
    }
}

@objc private extension MusicCommentViewController {
   
    //MARK: - @objc Method
    
    /// 팝업 관련 메서드
    func didTapGuide() {
        showPopup()
    }
    
    /// 글 등록 관련 메서드
    func didTapRegister() {
        let comment = textView.text ?? ""
        viewModel.didTapRegister(comment: comment)
    }
}

private extension MusicCommentViewController {
    
    // MARK: - Delegate
    
    func setupDelegate() {
        textView.delegate = self
    }
    
    // MARK: - Target
    
    func setupTarget() {
        navigationBarView.onTapBack = { [weak self] in
            self?.viewModel.didTapBack()
        }
        
        guideButton.addTarget(self, action: #selector(didTapGuide), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(didTapRegister), for: .touchUpInside)
    }
    
    private func showPopup() {
        
        // 이미 떠있으면 중복 X
        guard popupView == nil else { return }
        
        let popup = CommentGuidePopupView()
        popup.alpha = 0
        popup.layer.cornerRadius = 12
        popup.clipsToBounds = false
        
        view.addSubview(popup)
        self.popupView = popup
        
        popup.bindActions(close: { [weak self] in
            self?.hidePopup()
        }, learnMore: {
            print("더 알아보기 이동 예정 추후 웹뷰 연결")
        })
        
        popup.snp.makeConstraints {
            $0.top.equalTo(guideButton.snp.bottom).offset(8)
            $0.leading.equalTo(guideButton.snp.leading)
            $0.width.equalTo(305)
            $0.height.equalTo(134)
        }
        
        UIView.animate(withDuration: 0.25) {
            popup.alpha = 1
        }
    }
    
    private func hidePopup() {
        guard let popup = popupView else { return }
        
        UIView.animate(withDuration: 0.2, animations: {
            popup.alpha = 0
        }, completion: { _ in
            popup.removeFromSuperview()
            self.popupView = nil
        })
    }
}

// MARK: - UITextViewDelegate

extension MusicCommentViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
        countLabel.text = "\(textView.text.count)/150"
        
        let enable = textView.text.count > 0
        registerButton.isEnabled = enable
        
        if enable {
            registerButton.setTitleColor(.white, for: .normal)
            registerButton.backgroundColor = .dplay_pink
        } else {
            registerButton.setTitleColor(.gray400, for: .normal)
            registerButton.backgroundColor = .gray200
        }
    }
}
