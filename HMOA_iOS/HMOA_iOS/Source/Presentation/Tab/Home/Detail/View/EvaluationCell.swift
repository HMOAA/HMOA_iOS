//
//  EvaluationCell.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/08/01.
//

import UIKit

import Then
import ReactorKit
import SnapKit

class EvaluationCell: UICollectionViewCell, View {
    
    static let identifier = "EvaluationCell"
    var disposeBag = DisposeBag()
    //MARK: - UI Component
    
    //계절
    let evaluationLabel = UILabel().then {
        $0.setLabelUI("이 제품에 대해 평가해주세요",
                      font: .pretendard_medium,
                      size: 20,
                      color: .black)
    }
    
    let seasonLabel = UILabel().then {
        $0.setLabelUI("계절감",
                      font: .pretendard_medium,
                      size: 16,
                      color: .black)
    }
    
    let seasonButtonStackView = UIStackView().then {
        $0.distribution = .fillEqually
        $0.setStackViewUI(spacing: 16, axis: .horizontal)
    }
    lazy var springButton: UIButton = UIButton().then {
        $0.configuration = setSeasonButtonConfigure("spring")
        $0.backgroundColor = .customColor(.gray1)
        $0.layer.cornerRadius = 5
    }
    lazy var summerButton = UIButton().then {
        $0.configuration = setSeasonButtonConfigure("summer")
        $0.backgroundColor = .customColor(.gray1)
        $0.layer.cornerRadius = 5
    }
    lazy var fallButton = UIButton().then {
        $0.configuration = setSeasonButtonConfigure("fall")
        $0.backgroundColor = .customColor(.gray1)
        $0.layer.cornerRadius = 5
    }
    lazy var winterButton = UIButton().then {
        $0.configuration = setSeasonButtonConfigure("winter")
        $0.backgroundColor = .customColor(.gray1)
        $0.layer.cornerRadius = 5
    }
    
    lazy var buttons = [springButton, summerButton, fallButton, winterButton]
    lazy var originalImage = buttons.map {
        $0.configuration?.image
    }
    
    let seasonLabelStackView = UIStackView().then {
        $0.layer.masksToBounds = true
        $0.distribution = .fillEqually
        $0.setStackViewUI(spacing: 40, axis: .horizontal)
    }
    let springLabel = UILabel().then {
        $0.setLabelUI(" 봄",
                      font: .pretendard,
                      size: 16,
                      color: .black)
    }
    let summerLabel = UILabel().then {
        $0.setLabelUI("여름",
                      font: .pretendard,
                      size: 16,
                      color: .black)
    }
    let fallLabel = UILabel().then {
        $0.setLabelUI("가을",
                      font: .pretendard,
                      size: 16,
                      color: .black)
    }
    let winterLabel = UILabel().then {
        $0.setLabelUI("겨울",
                      font: .pretendard,
                      size: 16,
                      color: .black)
    }
    
    //성별
    let sexLabel = UILabel().then {
        $0.setLabelUI("성별",
                      font: .pretendard_medium,
                      size: 16,
                      color: .black)
    }
    
    let sexButtonView = UIView().then {
        $0.layer.cornerRadius = 5
        $0.backgroundColor = .customColor(.gray1)
    }
    let wommanButton = UIButton().then {
        $0.backgroundColor = .customColor(.gray2)
        $0.layer.cornerRadius = 5
        $0.setImage(UIImage(named: "woman"), for: .normal)
    }
    let uniSexButton = UIButton().then {
        $0.backgroundColor = .customColor(.gray2)
        $0.layer.cornerRadius = 5
        $0.setImage(UIImage(named: "uniSex"), for: .normal)
    }
    let manButton = UIButton().then {
        $0.backgroundColor = .customColor(.gray2)
        $0.layer.cornerRadius = 5
        $0.setImage(UIImage(named: "man"), for: .normal)
    }
    
    //평가된 성별 View
    lazy var evaluatedSexView = UIView().then {
        $0.layer.masksToBounds = true
        $0.isHidden = true
        $0.backgroundColor = .customColor(.gray1)
    }
    lazy var womanImageView = UIImageView().then {
        $0.image = UIImage(named: "woman")
    }
    lazy var manImageView = UIImageView().then {
        $0.image = UIImage(named: "man")
    }
    lazy var womanPercentLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_medium, size: 10, color: .white)
    }
    lazy var manPercentLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_medium, size: 10, color: .white)
    }

    let wommanLabel = UILabel().then {
        $0.setLabelUI("여성",
                      font: .pretendard,
                      size: 16,
                      color: .black)
    }
    let uniSexLabel = UILabel().then {
        $0.setLabelUI("중성",
                      font: .pretendard,
                      size: 16,
                      color: .black)
    }
    let manLabel = UILabel().then {
        $0.setLabelUI("남성",
                      font: .pretendard,
                      size: 16,
                      color: .black)
    }
    
    let ageLabel = UILabel().then {
        $0.setLabelUI("연령대",
                      font: .pretendard_medium,
                      size: 16,
                      color: .black)
    }
    
    let ageSlider = UISlider().then {
        $0.minimumValue = 0
        $0.maximumValue = 50
        $0.setThumbImage(UIImage(named: "arrowSlider"), for: .normal)
        $0.setMinimumTrackImage(UIImage(named: "minSlider"), for: .normal)
        $0.setMaximumTrackImage(UIImage(named: "maxSlider"), for: .normal)
    }
    
    let minAgeLabel = UILabel().then {
        $0.setLabelUI("10대",
                      font: .pretendard,
                      size: 16,
                      color: .black)
    }
    
    lazy var averageAgeLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard, size: 16, color: .black)
    }
    
    let maxAgeLabel = UILabel().then {
        $0.setLabelUI("50대 이상",
                      font: .pretendard,
                      size: 16,
                      color: .black)
    }
    
    lazy var evaluatedAgeView = UIView().then {
        $0.layer.masksToBounds = true
        $0.isHidden = true
        $0.layer.cornerRadius = 5
        $0.backgroundColor = .customColor(.gray1)
    }
    
    lazy var allCornerRadius: CACornerMask  = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
    
    
    
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        
        setUpUI()
        setAddView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setBlackLayer()
    }
    
    //MARK: - SetUp
    private func setUpUI() {
        
        //계절 버튼 검정색 배경 layer 추가
        buttons.forEach {
            let blackLayer = CALayer()
            blackLayer.frame = CGRect(x: 0, y: 80, width: 52, height: 0)
            blackLayer.backgroundColor = UIColor.black.cgColor
            blackLayer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            blackLayer.cornerRadius = 5
            $0.layer.addSublayer(blackLayer)
        }
    }
    
    private func setAddView() {
        
        // 계절 버튼 스택 뷰
        [
           springButton,
           summerButton,
           fallButton,
           winterButton
        ].forEach { seasonButtonStackView.addArrangedSubview($0) }
        
        // 계절 라벨 스택 뷰
        [
            springLabel,
            summerLabel,
            fallLabel,
            winterLabel
        ].forEach { seasonLabelStackView.addArrangedSubview($0) }
        
        // 성별 버튼 스택 뷰
        [
            wommanButton,
            uniSexButton,
            manButton
        ].forEach { sexButtonView.addSubview($0) }
        
        // 평가된 성별 뷰
        [
            womanImageView,
            womanPercentLabel,
            manImageView,
            manPercentLabel
        ]   .forEach { evaluatedSexView.addSubview($0) }
        
        [
            seasonLabel,
            seasonButtonStackView,
            seasonLabelStackView,
            sexLabel,
            sexButtonView,
            evaluatedSexView,
            wommanLabel,
            uniSexLabel,
            manLabel,
            ageLabel,
            ageSlider,
            minAgeLabel,
            averageAgeLabel,
            maxAgeLabel,
            evaluatedAgeView
        ].forEach { addSubview($0) }
        
    }
    
    private func setConstraints() {
        seasonLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.trailing.equalToSuperview()
        }
        
        seasonButtonStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(seasonLabel.snp.bottom).offset(16)
            make.width.equalTo(256)
            make.height.equalTo(80)
        }
        
        seasonLabelStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(seasonButtonStackView.snp.bottom).offset(16)
        }
        
        sexLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(seasonLabelStackView.snp.bottom).offset(40)
            make.trailing.equalToSuperview()
        }
        
        sexButtonView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(32)
            make.top.equalTo(sexLabel.snp.bottom).offset(16)
            make.height.equalTo(52)
        }
        
        wommanButton.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview()
            make.width.equalTo(52)
        }
        
        manButton.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
            make.width.equalTo(52)
        }
        
        uniSexButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalTo(52)
        }
        
        evaluatedSexView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(32)
            make.top.equalTo(sexLabel.snp.bottom).offset(16)
            make.height.equalTo(52)
        }
        
        womanImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(18)
            make.top.equalToSuperview().inset(14)
            make.width.height.equalTo(16)
        }
        
        womanPercentLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(18)
            make.top.equalTo(womanImageView.snp.bottom).offset(6)
        }
        
        manImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(18)
            make.top.equalToSuperview().inset(14)
            make.width.height.equalTo(16)
        }
        
        manPercentLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(15)
            make.top.equalTo(manImageView.snp.bottom).offset(5)
        }
        
        wommanLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(42)
            make.top.equalTo(sexButtonView.snp.bottom).offset(23)
        }
        
        uniSexLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(wommanLabel)
        }
        
        manLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(42)
            make.top.equalTo(wommanLabel)
        }
        
        ageLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalToSuperview()
            make.top.equalTo(wommanLabel.snp.bottom).offset(40)
        }
        
        ageSlider.snp.makeConstraints { make in
            make.top.equalTo(ageLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(32)
            make.height.equalTo(52)
        }
        
        minAgeLabel.snp.makeConstraints { make in
            make.top.equalTo(ageSlider.snp.bottom).offset(16)
            make.leading.equalToSuperview().inset(43)
        }
        
        averageAgeLabel.snp.makeConstraints { make in
            make.top.equalTo(minAgeLabel)
            make.centerX.equalToSuperview()
        }
        
        maxAgeLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(26)
            make.top.equalTo(ageSlider.snp.bottom).offset(16)
        }
        
        evaluatedAgeView.snp.makeConstraints { make in
            make.top.equalTo(ageLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(32)
            make.height.equalTo(52)
        }
    }
    
    func bind(reactor: EvaluationReactor) {
        
        // Action
        
        //ViewDidLoad
        Observable.just(())
            .map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 슬라이더 값 바뀔 때
        ageSlider.rx.value
            .map { Reactor.Action.isChangingAgeSlider($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        // 슬라이더에서 손 땠을 때
        ageSlider.rx.controlEvent(.touchUpInside)
            .map { reactor.currentState.sliderStep }
            .map { Reactor.Action.didChangeAgeSlider($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 계절 버튼 터치
        Observable.merge(
            springButton.rx.tap.map { 1 },
            summerButton.rx.tap.map { 2 },
            fallButton.rx.tap.map { 3 },
            winterButton.rx.tap.map { 4 })
        .map { Reactor.Action.didTapSeasonButton($0) }
        .bind(to: reactor.action)
        .disposed(by: disposeBag)
        
        //성별 버튼 터치
        Observable.merge(
            manButton.rx.tap.map { 1 },
            wommanButton.rx.tap.map { 2 },
            uniSexButton.rx.tap.map { 3 })
        .map { Reactor.Action.didTapGenderButton($0) }
        .bind(to: reactor.action)
        .disposed(by: disposeBag)
        
        
        // weather 평가 값 계절 버튼에 binding
        reactor.state
            .map { $0.weather }
            .compactMap { $0 }
            .bind(onNext: setSeasonButtonBackgroundColor)
            .disposed(by: disposeBag)
        
        // gender 평가 값 binding
        reactor.state
            .map { $0.gender }
            .compactMap { $0 }
            .bind(onNext: setGenderViewColor)
            .disposed(by: disposeBag)
        
        // 슬라이더 10 단위로 맞추기
        reactor.state
            .map { $0.sliderStep }
            .skip(1)
            .bind(to: ageSlider.rx.value)
            .disposed(by: disposeBag)
        
        // 슬라이더 10단위로 진동 주기
        reactor.state
            .map { $0.sliderStep }
            .skip(1)
            .distinctUntilChanged()
            .filter { $0 != 0 }
            .bind(onNext: { _ in
                let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
                feedbackGenerator.impactOccurred()
            })
            .disposed(by: disposeBag)
        
        // age 평가 값 binding
        reactor.state
            .map { $0.age }
            .compactMap { $0 }
            .bind(onNext: setAgeSliderColor)
            .disposed(by: disposeBag)
    }
}

extension EvaluationCell {
    
    // ageSlider 배경색, 텍스트 설정
    private func setAgeSliderColor(_ age: Age) {

        ageSlider.isHidden = true
        evaluatedAgeView.isHidden = false
    
        let percent = CGFloat(age.age) / 50.0
        let frame = evaluatedAgeView.frame
        
        if age.age == 50 {
            evaluatedAgeView.layer.sublayers?[0].maskedCorners = allCornerRadius
        }
    
        evaluatedAgeView.layer.sublayers?[0].frame = CGRect(x: 0, y: 0, width: frame.width * percent, height: frame.height)
        
        averageAgeLabel.text = "평균 \(age.age)세"
        
    }
    
    // genderView 배경색, 텍스트 설정
    // TODO: - 범위에 따른 image, text 색 변경
    private func setGenderViewColor(_ gender: Gender) {
        sexButtonView.isHidden = true
        evaluatedSexView.isHidden = false
        
        let frame = evaluatedSexView.frame
        
        if gender.woman >= 50 {
            if gender.woman == 100 {
                evaluatedSexView.layer.sublayers?[0].maskedCorners = allCornerRadius
            }
            let womanPercent = CGFloat(gender.woman) / 100.0
            evaluatedSexView.layer.sublayers?[0].frame = CGRect(x: 0, y: 0, width: frame.width * womanPercent, height: frame.height)
        } else {
            let manPercent = CGFloat(gender.man) / 100.0
            evaluatedSexView.layer.sublayers?[1].frame = CGRect(x: frame.maxX - 32, y: 0, width: frame.width * -manPercent, height: frame.height)
            if gender.man == 100 {
                evaluatedSexView.layer.sublayers?[1].maskedCorners = allCornerRadius
            }
        }
        womanPercentLabel.text = "\(gender.woman)%"
        manPercentLabel.text = "\(gender.man)%"
    }
    
    // 계절 버튼 배경색, 텍스트 설정
    private func setSeasonButtonBackgroundColor(_ weather: Weather) {
        
        let weatherValues = [weather.spring, weather.summer, weather.autumn, weather.winter]
        
        var isChangedTitleColor = [Bool](repeating: false, count: 4)
        var isChangedImageColor = [Bool](repeating: false, count: 4)
        
        for (index, value) in weatherValues.enumerated() {
            
            let percent = CGFloat(value) / 100.0
            //검정색 배경 채우기
            if percent != 0 {
                //100%라 모든 면을 둥글게 해야 할 때
                if percent == 1 {
                    buttons[index].layer.sublayers?[1].maskedCorners = allCornerRadius
                }
                //100%여서 다시 윗 모서리 둥글게를 없애야 할 때
                else if buttons[index].layer.sublayers?[1].maskedCorners == allCornerRadius {
                    buttons[index].layer.sublayers?[1].maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
                }
                let frame = CGRect(x: 0, y: 80, width: 52, height: 80 * -percent)
                buttons[index].layer.sublayers?[1].frame = frame
            } else {
                if buttons[index].layer.sublayers?[1].frame.size.height != 0 {
                    let frame = CGRect(x: 0, y: 80, width: 52, height: 0)
                    buttons[index].layer.sublayers?[1].frame = frame
                }
            }
            
            //이미지 색상 변경
            if value > 60 && !isChangedImageColor[index] {
                buttons[index].configuration?.image = buttons[index].configuration?.image?.withTintColor(.white)
                isChangedImageColor[index] = true
            } else {
                buttons[index].configuration?.image = originalImage[index]
                isChangedImageColor[index] = false
            }
            
            //타이틀 색상 변경
            if value > 70 && !isChangedTitleColor[index] {
                buttons[index].configuration?.baseForegroundColor = .white
                isChangedTitleColor[index] = true
            } else {
                buttons[index].configuration?.baseForegroundColor = .black
                isChangedTitleColor[index] = false
            }
            
            //버튼 타이틀 설정
            buttons[index].configuration?.attributedTitle = AttributedString() .setButtonAttirbuteString(text: "\(value)%", size: 10, font: .pretendard_medium)
        }
    }
    
    private func setSeasonButtonConfigure(_ image: String) -> UIButton.Configuration {
        var config = UIButton.Configuration.plain()
        var titleAttr = AttributedString(" ")
        titleAttr.font = .customFont(.pretendard_medium, 10)
        config.attributedTitle = titleAttr
        config.titleAlignment = .center
        config.baseForegroundColor = .black
        config.image = UIImage(named: image)
        config.imagePlacement = .bottom
        config.imagePadding = 15
        config.contentInsets = .init(top: 0, leading: 0, bottom: 26, trailing: 0)
        
        return config
    }
    
    private func setBlackLayer() {
        
        lazy var blackWomanLayer = CALayer()
        lazy var blackManLayer = CALayer()
        lazy var blackAgeLayer = CALayer()
        
        lazy var layers = [blackManLayer, blackWomanLayer, blackAgeLayer]
        lazy var frame = evaluatedSexView.frame
        
        blackManLayer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMaxYCorner]
        blackWomanLayer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        blackAgeLayer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        
        
        blackWomanLayer.frame = CGRect(x: 0, y: 0, width: 0, height: frame.height)
        blackManLayer.frame = CGRect(x: frame.maxX - 32, y: 0, width: 0, height: frame.height)
        blackAgeLayer.frame = CGRect(x: 0, y: 0, width: 0, height: frame.height)
        
        layers.forEach {
            $0.cornerRadius = 5
            $0.backgroundColor = UIColor.black.cgColor
        }
        
        evaluatedSexView.layer.insertSublayer(blackWomanLayer, at: 0)
        evaluatedSexView.layer.insertSublayer(blackManLayer, at: 1)
        evaluatedAgeView.layer.insertSublayer(blackAgeLayer, at: 0)
    }
}
