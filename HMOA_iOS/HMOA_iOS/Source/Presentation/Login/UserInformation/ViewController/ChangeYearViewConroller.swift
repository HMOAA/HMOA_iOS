//
//  ChangeYearViewConroller.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/03/31.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

class ChangeYearViewConroller: UIViewController {

    //MARK: - Property
    
    let birthYearLabel = UILabel().then {
        $0.setLabelUI("출생연도", font: .pretendard_medium, size: 16, color: .black)
    }
    
    let selectYearView = UIView()
    let selectLabel = UILabel().then {
        $0.setLabelUI("선택", font: .pretendard, size: 16, color: .gray3)
    }
    let selectYearButton = UIButton().then {
        $0.setImage(UIImage(named: "downPolygon"), for: .normal)
    }
    
    let changeButton = UIButton().then {
        $0.isEnabled = false
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .customColor(.gray2)
        $0.titleLabel?.font = .customFont(.pretendard, 20)
        $0.setTitle("변경", for: .normal)
    }
    
    let reactor = ChangeYearReactor()
    var disposeBag = DisposeBag()
    
    let yearList = Year().year

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBarTitle(title: "닉네임 변경", color: .white, isHidden: false)
        setUpUI()
        setAddView()
        setUpConstraints()
        
        bind(reactor: reactor)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let frame = selectYearView.frame
        setBottomBorder(selectYearView, width: frame.width, height: frame.height)
    }
    
    //MARK: - SetUp
    private func setUpUI() {
        view.backgroundColor = .white
    }
    
    
    private func setAddView() {
        [
            selectLabel,
            selectYearButton
        ].forEach { selectYearView.addSubview($0) }
        
        [
            birthYearLabel,
            selectYearView,
            changeButton
        ].forEach { view.addSubview($0) }
    }
    
    private func setUpConstraints() {
        
        birthYearLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(34)
            make.leading.equalToSuperview().inset(16)
        }
        
        selectLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        selectYearButton.snp.makeConstraints { make in
            make.leading.equalTo(selectLabel.snp.trailing)
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
        
        selectYearView.snp.makeConstraints { make in
            make.top.equalTo(birthYearLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().inset(16)
            make.width.equalTo(view.frame.width/2 - 16)
            make.height.equalTo(46)
        }
        
        changeButton.snp.makeConstraints { make in
            make.height.equalTo(80)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    //MARK: - Bind
    private func bind(reactor: ChangeYearReactor) {
        //Input
        
        //연도 선택 터치 이벤트
        selectYearButton.rx.tap
            .map { ChangeYearReactor.Action.didTapChoiceYearButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        //시작 버튼 터치 이베느
        changeButton.rx.tap
            .map { ChangeYearReactor.Action.didTapChangeButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        //OutPut
        
        //ChoiceYearVC로 이동 및 년도 값 받아와 UI 업데이트
        reactor.state
            .map { $0.isPresentChoiceYearVC }
            .distinctUntilChanged()
            .filter { $0 }
            .bind(onNext: { _ in
                let yearVC = self.presentSelectYear()
                self.present(yearVC, animated: true)
                self.updateYearLabel(yearVC)
            }).disposed(by: disposeBag)
        
        //Mypage로 pop
        reactor.state
            .map { $0.isPopMyPage }
            .distinctUntilChanged()
            .filter { $0 }
            .bind(onNext: { _ in
                self.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
        
    }
    
}

extension ChangeYearViewConroller {
    //MARK: - Functions
    
    //selectLabel text 변경
    func updateYearLabel(_ vc: ChoiceYearViewController) {
        vc.reactor.state
            .map { $0.selectedIndex}
            .distinctUntilChanged()
            .bind(onNext: { index in
                self.updateUIStartAndYear(index)
                self.selectLabel.text = self.yearList[index]
            }).disposed(by: disposeBag)
    }
    
    //selectLabel, changeButton UI 변경
    func updateUIStartAndYear(_ index: Int) {
        if index != 0{
            selectLabel.textColor = .black
            changeButton.backgroundColor = .black
            changeButton.isEnabled = true
        }
        
        else {
            selectLabel.textColor = .customColor(.gray3)
            changeButton.backgroundColor = .customColor(.gray2)
            changeButton.isEnabled = false
        }
    }
    
    func presentSelectYear() -> ChoiceYearViewController {
        let vc = ChoiceYearViewController()
        vc.modalPresentationStyle = .pageSheet
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.largestUndimmedDetentIdentifier = .medium
        }
        return vc
    }
}
