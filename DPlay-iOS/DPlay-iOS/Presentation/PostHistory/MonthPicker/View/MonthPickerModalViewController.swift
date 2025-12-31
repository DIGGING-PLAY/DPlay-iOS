//
//  MonthPickerModalViewController.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 12/31/25.
//

import UIKit

import SnapKit
import Then

final class MonthPickerModalViewController: UIViewController {
    
    //MARK: - Action
    
    private let onTapSelectButton: ((Int, Int) -> Void)?
    
    //MARK: - Properties
    
    private var selectedYear: Int
    private var selectedMonth: Int
    
    private var years = [2022] //출시 년도 기준이라 원래 초기값은 2026이지만 테스트를 위해 작게 잡아둠
    private let months = Array(1...12)
        
    //MARK: - UI Properties

    private let closeButton = UIButton()
    private let titleLabel = UILabel()
    private let monthPickerView = UIPickerView()
    private let selectButton = UIButton()

    //MARK: - Life Cycle
    
    init(
        selectedYear: Int,
        selectedMonth: Int,
        onTapSelectButton: @escaping ((Int, Int) -> Void)
    ) {
        self.selectedYear = selectedYear
        self.selectedMonth = selectedMonth
        self.onTapSelectButton = onTapSelectButton
        
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
        setupPickerView()
        
        bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
     
    }
}

private extension MonthPickerModalViewController {
    
    //MARK: - setup
    
    func setupStyle() {
        view.backgroundColor = .white
        
        closeButton.do {
            $0.setImage(IconLiterals.ic_close_24, for: .normal)
        }
                
        titleLabel.do {
            $0.text = "날짜를 선택해주세요"
            $0.setTextStyle(.titleBold18)
            $0.textColor = .dplay_black
        }
        
        monthPickerView.do {
            $0.delegate = self
            $0.dataSource = self
        }
        
        selectButton.do {
            $0.backgroundColor = .gray600
            $0.setTitle("선택하기", for: .normal)
            $0.titleLabel?.setTextStyle(.bodyBold16)
            $0.roundCorners(cornerRadius: 12)
        }
    }
    
    func setupHierarchy() {
        view.addSubviews(
            closeButton,
            titleLabel,
            monthPickerView,
            selectButton
        )
    }
    
    func setupLayout() {
        closeButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(closeButton)
            $0.leading.equalToSuperview().inset(16)
        }
        
        monthPickerView.snp.makeConstraints {
            $0.top.equalTo(closeButton.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        selectButton.snp.makeConstraints {
            $0.top.equalTo(monthPickerView.snp.bottom).offset(16)
            $0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.height.equalTo(52)
        }
    }
}

@objc private extension MonthPickerModalViewController {
    
    //MARK: - @objc Method
    
    func closeButtonTapped() {
        dismiss(animated: true)
    }
    
    func selectButtonTapped() {
        dismiss(animated: true) { [weak self] in
            guard let self else { return }
            
            //클로저를 통해 최신 값 반환
            onTapSelectButton?(selectedYear, selectedMonth)
        }
    }
    
}

private extension MonthPickerModalViewController {
    
    // MARK: - Private Method
    
    func setupTarget() {
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        selectButton.addTarget(self, action: #selector(selectButtonTapped), for: .touchUpInside)
    }
    
    func setupPickerView() {
        let currentDate = Date()
        let minYear = years[0]
        let maxYear = Calendar.current.component(.year, from: currentDate)
        
        //현재 연도가 최소(앱 출시) 연도보다 큰 경우에 years 배열에 추가
        if maxYear > minYear {
            years.append(contentsOf: Array(minYear + 1...maxYear))
        }
        
        //현재 선택되어있는 연도/월이 기본 값으로 포커싱 되도록 업데이트
        if let yearRow = years.firstIndex(of: selectedYear), let monthRow = months.firstIndex(of: selectedMonth) {
            DispatchQueue.main.async {
                self.monthPickerView.selectRow(yearRow, inComponent: 0, animated: false)
                self.monthPickerView.selectRow(monthRow, inComponent: 1, animated: false)
            }
        }
    }
    
    func bindViewModel() {
    }
}

extension MonthPickerModalViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return years.count
        } else {
            return months.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
}
 
extension MonthPickerModalViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        
        //component: 0(year)/1(month)
        if component == 0  {
            label.text = "\(years[row])년"
            label.textColor = years[row] == selectedYear ? .gray600 : .gray400
        } else {
            label.text = "\(months[row])월"
            label.textColor = months[row] == selectedMonth ? .gray600 : .gray400
        }

        label.textAlignment = .center
        label.setTextStyle(.bodySemi16)

        return label
    }

    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        if component == 0 {
            return 90
        } else {
            return 50
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        //선택 행이 달라지면 UI와 값 업데이트
        pickerView.reloadComponent(component)
        
        if component == 0 {
            selectedYear = years[row]
        } else {
            selectedMonth = months[row]
        }
    }
}
