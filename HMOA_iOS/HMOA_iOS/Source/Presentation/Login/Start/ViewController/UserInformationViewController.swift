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
import ReactorKit

class UserInformationViewController: UIViewController, View {
    
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
    
    var reactor: UserInformationReactor
    var disposeBag = DisposeBag()
    let loginManager = LoginManager.shared
    
    let yearList = Year().year
    var index: Int = 0
    var nickname: String = ""
    var subscription: Disposable?
    //MARK: - Init
    init(nickname: String = "", reactor: UserInformationReactor) {
        //닉네임 페이지에서 닉네임 받아오기
        self.reactor = reactor
        self.nickname = nickname
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBarTitle(title: "회원가입", color: .white, isHidden: false)
        setUpUI()
        setAddView()
        setUpConstraints()
        bind(reactor: self.reactor)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let frame = selectYearView.frame
        setBottomBorder(selectYearView, width: frame.width, height: frame.height)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // 구독 해제
        subscription?.dispose()
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
        config.baseForegroundColor = .black
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
    func bind(reactor: UserInformationReactor) {
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
        
        //시작 버튼 터치 이벤트
        startButton.rx.tap
            .map { UserInformationReactor.Action.didTapStartButton(self.nickname) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        //OutPut
        
        //ChoiceYearVC로 이동 및 년도 값 받아와 UI 업데이트
        reactor.state
            .map { $0.isPresentChoiceYearVC }
            .distinctUntilChanged()
            .filter { $0 }
            .bind(with: self, onNext: { owner, _ in
                let yearVC = owner.presentSelectYear()
                owner.present(yearVC, animated: true)
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
            .map { $0.selectedYear }
            .distinctUntilChanged()
            .compactMap { $0 }
            .bind(with: self, onNext: { owner, year in
                owner.selectLabel.text = year
                owner.updateUIYearLabel(year)
            }).disposed(by: disposeBag)
        
        //StartButton Enable 설정
        reactor.state
            .map { $0.isStartEnable }
            .distinctUntilChanged()
            .bind(with: self, onNext: { owner, isStart in
                owner.setEnableStartButton(isStart)
            }).disposed(by: disposeBag)
        
        //메인 탭바로 이동
        subscription = Observable.combineLatest(
            reactor.state.map { $0.joinResponse }
                .distinctUntilChanged()
                .filter { $0 != nil },
            loginManager.loginStateSubject,
            loginManager.tokenSubject
        )
            .bind(with: self, onNext: { owner, login in
                guard var token = login.2 else { return }
                DispatchQueue.main.async {
                    owner.presentTabBar(login.1)
                    owner.loginManager.isLogin.onNext(true)
                    token.existedMember = true
                    owner.loginManager.tokenSubject.onNext(token)
                    KeychainManager.create(token: token)
                }
            })
    }
    
    //MARK: - UpdateUI
    func updateUIYearLabel(_ year: String) {
        if year == "선택" {
            selectLabel.textColor = .customColor(.gray3)
            setEnableStartButton(false)
        }
        
        else {
            selectLabel.textColor = .black
        }
    }
    
    func setEnableStartButton(_ isEnable: Bool) {
        if isEnable {
            startButton.backgroundColor = .black
            startButton.isEnabled = true
        }
        
        else {
            startButton.backgroundColor = .customColor(.gray2)
            startButton.isEnabled = false
        }
    }
    
    func presentSelectYear() -> ChoiceYearViewController {
        
        let choiceYearReactor = reactor.reactorForChoiceYear()
        let vc = ChoiceYearViewController(reactor: choiceYearReactor)
        
        vc.modalPresentationStyle = .pageSheet
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.largestUndimmedDetentIdentifier = .medium
        }
        return vc
    }
}
