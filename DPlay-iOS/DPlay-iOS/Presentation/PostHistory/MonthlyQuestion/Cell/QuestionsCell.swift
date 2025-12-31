//
//  QuestionsCell.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 12/31/25.
//

import UIKit

import SnapKit
import Then
import Kingfisher

final class QuestionsCell: UITableViewCell {
    
    // MARK: - UI Properties
    
    private let dayView = UIView()
    private let dayLabel = UILabel()
    private let questionView = UIView()
    private let questionLabel = UILabel()
    private let stackView = UIStackView()

    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 12, right: 0))
    }
}

private extension QuestionsCell {
    
    // MARK: - Layout
    
    func setupStyle() {
        backgroundColor = .white
        selectionStyle = .none
        
        dayView.do {
            $0.backgroundColor = .gray600
            $0.roundCorners(cornerRadius: 8)
        }
        
        dayLabel.do {
            $0.text = "1일"
            $0.setTextStyle(.bodyBold14)
            $0.textColor = .gray100
        }
        
        questionView.do {
            $0.backgroundColor = .gray100
            $0.layer.borderColor = UIColor.gray200.cgColor
            $0.layer.borderWidth = 1
            $0.roundCorners(cornerRadius: 8)
        }
        
        questionLabel.do {
            $0.text = "여행 갈 때 플레이리스트에 꼭 넣는 노래는?"
            $0.setTextStyle(.bodySemi14)
            $0.textColor = .gray600
        }
        
        stackView.do {
            $0.axis = .horizontal
        }
    }
    
    func setupHierarchy() {
        contentView.addSubviews(
            stackView
        )
        
        dayView.addSubview(dayLabel)
        questionView.addSubview(questionLabel)
        
        stackView.addArrangedSubviews(dayView, questionView)
    }
    
    func setupLayout() {
        
        dayView.snp.makeConstraints {
            $0.width.equalTo(52)
        }
        
        dayLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        questionLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(10)
        }
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(64)
        }
    }
}

extension QuestionsCell {
    
    // MARK: - Configure
    
    func configure(question: MonthlyQuestion) {
        dayLabel.text = question.day
        questionLabel.text = question.title
    }
}
