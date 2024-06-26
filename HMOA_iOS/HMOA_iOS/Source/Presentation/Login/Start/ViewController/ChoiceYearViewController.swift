//
//  ChoiceYearViewController.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/02/24.
//

import UIKit

import SnapKit
import Then
import RxCocoa
import RxSwift
import ReactorKit

class ChoiceYearViewController: UIViewController, View {
    
    // MARK: - Property

    var reactor: ChoiceYearReactor
    var disposeBag = DisposeBag()
    let yearList = Year().year

    // MARK: - UIComponents
    
    private let xButton = UIButton().then {
        $0.setImage(UIImage(named: "x"), for: .normal)
    }
    
    private let birthYearLabel = UILabel().then {
        $0.setLabelUI("출생 연도", font: .pretendard, size: 16, color: .black)
    }
    
    private let yearPicker = UIPickerView()
    
    private let okButton = UIButton().then {
        $0.titleLabel?.font = .customFont(.pretendard_semibold, 16)
        $0.setTitle("확인", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .black
    }

    // MARK: - init
    init(reactor: ChoiceYearReactor) {
        self.reactor = reactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        setAddView()
        setConstraints()
        bind(reactor: reactor)
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        yearPicker.subviews[1].backgroundColor = .clear
        let frame = view.frame
        let upLine = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: 1))
        let underLine = UIView(frame: CGRect(x: 0, y: 40, width: frame.width, height: 1))
                
        upLine.backgroundColor = .customColor(.gray2)
        underLine.backgroundColor = .customColor(.gray2)
    
        yearPicker.subviews[1].addSubview(upLine)
        yearPicker.subviews[1].addSubview(underLine)
        
    }
    
    // MARK: - SetUp
    private func setUpUI() {
        yearPicker.dataSource = self
        view.backgroundColor = .white
    }
    
    private func setAddView() {
        [xButton, birthYearLabel, yearPicker, okButton].forEach { view.addSubview($0) }
    }
    
    private func setConstraints() {
        
        xButton.snp.makeConstraints { make in
            make.width.height.equalTo(12)
            make.top.equalToSuperview().inset(23)
            make.trailing.equalToSuperview().inset(22)
        }
        
        birthYearLabel.snp.makeConstraints { make in
            make.top.equalTo(xButton.snp.bottom).offset(2)
            make.leading.equalToSuperview().inset(38)
        }
        
        yearPicker.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        
        okButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(24)
            make.width.equalTo(200)
            make.height.equalTo(40)
        }
    }
    
    func bind(reactor: ChoiceYearReactor) {
        
        xButton.rx.tap
            .map { ChoiceYearReactor.Action.didTapXButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        okButton.rx.tap
            .map { ChoiceYearReactor.Action.didTapOkButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        yearPicker.rx.itemSelected
            .map { ChoiceYearReactor.Action.didSelecteYear($0.row) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        yearPicker.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isDismiss }
            .distinctUntilChanged()
            .filter { $0 }
            .asDriver(onErrorRecover: { _ in .empty() })
            .drive(with: self, onNext: { owner, _ in
                owner.dismiss(animated: true)
            }).disposed(by: disposeBag)
        
    }
}

// MARK: - PickerView

extension ChoiceYearViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return yearList.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return yearList[row]
    }
}

