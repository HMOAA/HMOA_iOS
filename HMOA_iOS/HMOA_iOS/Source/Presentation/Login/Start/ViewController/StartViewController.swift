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

class StartViewController: UIViewController {
    
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
    
    let viewModel = StartViewModel()
    var disposeBag = DisposeBag()

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBarTitle(title: "회원가입", color: .white, isHidden: false)
        setUpUI()
        setAddView()
        setUpConstraints()
        
        bind()
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
    private func bind() {
        
        //연도 선택 터치 이벤트
        selectYearButton.rx.tap
            .subscribe(onNext: {
                let vc = self.viewModel.presentSelectYear()
                self.present(vc, animated: true)
                self.updateYearLabel(vc)
            }).disposed(by: disposeBag)
        
        //여성 버튼 터치 이벤트
        womanButton.rx.tap
            .bind(onNext: {
                self.viewModel.womanButtonOb.onNext(true)
                self.viewModel.manButtonOb.onNext(false)
            }).disposed(by: disposeBag)
            
        //남성 버튼 터치 이벤트
        manButton.rx.tap
            .bind(onNext: {
                self.viewModel.womanButtonOb.onNext(false)
                self.viewModel.manButtonOb.onNext(true)
            }).disposed(by: disposeBag)
        
        viewModel.manButtonOb
            .bind(to: self.manButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        viewModel.womanButtonOb
            .bind(to: self.womanButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        viewModel.isComplete
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { result in
                self.updateStartButton(result)
            }).disposed(by: disposeBag)
        
        //시작 버튼 터치 이벤트
        startButton.rx.tap
            .subscribe(onNext: {
                let tabBar = AppTabbarController()
                tabBar.modalPresentationStyle = .fullScreen
                self.present(tabBar, animated: true)
            }).disposed(by: disposeBag)
    }

    
    
    //MARK: - UpdateUI
    func updateYearLabel(_ vc: ChoiceYearViewController) {
       vc.viewModel.selectedIndex
            .map { vc.viewModel.years[$0] }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { year in
                self.viewModel.yearTextOb.onNext("selected")
                self.selectLabel.text = "\(year)"
                self.selectLabel.textColor = .black
            }).disposed(by: disposeBag)
    }
    
    func updateStartButton(_ result: Bool) {
        if result {
            startButton.backgroundColor = .black
            startButton.isEnabled = result
        }
        else {
            startButton.backgroundColor = .customColor(.gray2)
            startButton.isEnabled = result
        }
    }
}
