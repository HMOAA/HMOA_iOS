//
//  StartViewController.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/01/24.
//

import UIKit

import SnapKit
import Then
import RxCocoa
import RxSwift

class UserInformationViewController: UIViewController {
    
    //MARK: - Property
    let titleLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.text = """
        나에게 꼭 맞는
        향수 추천을 위한
        3초
        """
        $0.font = .customFont(.pretendard, 30)
    }
    
    let explainLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.text = """
        출생연도와 성별을 설정하면,
        나와 비슷한 사람들이 찾아보는 향수를 추천받을 수 있어요
        """
        $0.font = .customFont(.pretendard, 14)
    }
    
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
    
    let sexStackView = UIStackView().then {
        $0.setStackViewUI(spacing: 16, axis: .horizontal)
    }
    var womanButton: UIButton!
    var manButton: UIButton!
    
    let startButton = UIButton().then {
        $0.isEnabled = false
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .customColor(.gray2)
        $0.titleLabel?.font = .customFont(.pretendard, 20)
        $0.setTitle("시작하기", for: .normal)
    }
    
    let reactor = UserInformationReactor()
    var disposeBag = DisposeBag()
    
    let yearList = Year().year
    var index: Int = 0

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBarTitle(title: "회원가입", color: .white, isHidden: false)
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
        
        womanButton = UIButton(configuration: configureButton("여성"))
        manButton = UIButton(configuration: configureButton("남성"))
        womanButton.setImage(UIImage(named: "circle"), for: .normal)
        womanButton.setImage(UIImage(named: "selectCircle"), for: .selected)
        manButton.setImage(UIImage(named: "selectCircle"), for: .selected)
        manButton.setImage(UIImage(named: "circle"), for: .normal)
    
    }
    
    private func configureButton(_ title: String) -> UIButton.Configuration {
        var config = UIButton.Configuration.plain()
        
        var titleAttr = AttributedString.init(title)
        titleAttr.font = .customFont(.pretendard, 16)
        titleAttr.foregroundColor = .black
        
        config.baseBackgroundColor = .white
        config.imagePadding = 12
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        config.attributedTitle = titleAttr
        
        return config
    }
    
    private func setAddView() {
        [selectLabel, selectYearButton].forEach { selectYearView.addSubview($0) }
        
        [womanButton, manButton].forEach { sexStackView.addArrangedSubview($0) }
        
        [titleLabel, explainLabel, birthYearLabel, selectYearView, sexStackView, startButton].forEach { view.addSubview($0) }
    }
    
    private func setUpConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.leading.equalToSuperview().inset(16)
        }
        
        explainLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        birthYearLabel.snp.makeConstraints { make in
            make.top.equalTo(explainLabel.snp.bottom).offset(34)
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
            make.width.equalTo(152)
            make.height.equalTo(46)
        }
        
        sexStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(selectYearView.snp.bottom).offset(38)
        }
        
        startButton.snp.makeConstraints { make in
            make.height.equalTo(80)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    //MARK: - Bind
    private func bind(reactor: UserInformationReactor) {
        //Input
        
        //연도 선택 터치 이벤트
        selectYearButton.rx.tap
            .map { UserInformationReactor.Action.didTapChoiceYearButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        //여성 버튼 터치 이벤트
        womanButton.rx.tap
            .map { UserInformationReactor.Action.didTapWomanButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        //남성 버튼 터치 이벤트
        manButton.rx.tap
            .map { UserInformationReactor.Action.didTapManButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        //시작 버튼 터치 이베느
        startButton.rx.tap
            .map { UserInformationReactor.Action.didTapStartButton }
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
        
        //woman 버튼 활성화
        reactor.state
            .map { $0.isCheckedWoman }
            .distinctUntilChanged()
            .bind(to: self.womanButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        //man 버튼 활성화
        reactor.state
            .map { $0.isCheckedMan }
            .distinctUntilChanged()
            .bind(to: self.manButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        //성별 버튼 활성화 체크 및 UI 업데이트
        reactor.state
            .map { $0.isSexCheck }
            .distinctUntilChanged()
            .bind(onNext: { isSexCheck in
                self.updateUIStartAndYear(self.index, isSexCheck)
            }).disposed(by: disposeBag)
        
        //메인 탭바로 이동
        reactor.state
            .map { $0.isPresentTabBar }
            .distinctUntilChanged()
            .filter { $0 }
            .bind(onNext: { _ in
                let tabBar = AppTabbarController()
                tabBar.modalPresentationStyle = .fullScreen
                self.present(tabBar, animated: true)
            }).disposed(by: disposeBag)
    }
    
    //MARK: - UpdateUI
    
    //selectLabel text 변경
    func updateYearLabel(_ vc: ChoiceYearViewController) {
        vc.reactor.state
            .map { $0.selectedIndex}
            .distinctUntilChanged()
            .bind(onNext: { index in
                self.index = index
                self.updateUIStartAndYear(index, self.reactor.currentState.isSexCheck)
                self.selectLabel.text = self.yearList[index]
            }).disposed(by: disposeBag)
    }
    
    //selectLabel, StartButton UI 변경
    func updateUIStartAndYear(_ index: Int, _ isSexCheck: Bool) {
        if index != 0{
            if isSexCheck {
                startButton.backgroundColor = .black
                startButton.isEnabled = true
            }
            selectLabel.textColor = .black
        }
        
        else {
            selectLabel.textColor = .customColor(.gray3)
            startButton.backgroundColor = .customColor(.gray2)
            startButton.isEnabled = false
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
