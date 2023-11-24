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
import RxAppState

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
    
    lazy var seasonButtons = [springButton, summerButton, fallButton, winterButton]
    
    
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
    
    let seasonExplainLabel = UILabel().then {
        $0.setLabelUI("여러분의 생각을 투표해주세요", font: .pretendard, size: 12, color: .black)
    }
    
    //성별
    let sexLabel = UILabel().then {
        $0.setLabelUI("성별",
                      font: .pretendard_medium,
                      size: 16,
                      color: .black)
    }
    
    let sexButtonStackView = UIStackView().then {
        $0.distribution = .fillEqually
        $0.setStackViewUI(spacing: 40, axis: .horizontal)
    }
    lazy var manButton: UIButton = UIButton().then {
        $0.configuration = setSeasonButtonConfigure("man")
        $0.backgroundColor = .customColor(.gray1)
        $0.layer.cornerRadius = 5
    }
    lazy var uniSexButton = UIButton().then {
        $0.configuration = setSeasonButtonConfigure("uniSex")
        $0.backgroundColor = .customColor(.gray1)
        $0.layer.cornerRadius = 5
    }
    lazy var womanButton = UIButton().then {
        $0.configuration = setSeasonButtonConfigure("woman")
        $0.backgroundColor = .customColor(.gray1)
        $0.layer.cornerRadius = 5
    }
    
    lazy var sexButtons = [manButton, uniSexButton, womanButton]
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
    
    let sexExplainLabel = UILabel().then {
        $0.setLabelUI("여러분의 생각을 투표해주세요", font: .pretendard, size: 12, color: .black)
    }
    
    // 성별
    let ageLabel = UILabel().then {
        $0.setLabelUI("연령대",
                      font: .pretendard_medium,
                      size: 16,
                      color: .black)
    }
    
    lazy var ageResetButton = UIButton().then {
        $0.setImage(UIImage(named: "ageReset"), for: .normal)
        $0.isHidden = true
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
    
    lazy var dragLabel = UILabel().then {
        $0.setLabelUI("드래그 해주세요", font: .pretendard, size: 16, color: .gray2)
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
        setBlackLayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - SetUp
    private func setUpUI() {
        
        //계절 버튼 검정색 배경 layer 추가
        seasonButtons.forEach {
            $0.layer.addSublayer(setVerticalBlackLayer())
        }
        
        sexButtons.forEach {
            $0.layer.addSublayer(setVerticalBlackLayer())
        }
        
        
    }
    
    private func setAddView() {
        
        // 계절 버튼 스택 뷰
        seasonButtons.forEach { seasonButtonStackView.addArrangedSubview($0) }
        
        // 계절 라벨 스택 뷰
        [
            springLabel,
            summerLabel,
            fallLabel,
            winterLabel
        ].forEach { seasonLabelStackView.addArrangedSubview($0) }
        
        // 성별 버튼 스택 뷰
        sexButtons.forEach { sexButtonStackView.addArrangedSubview($0) }

        [
            seasonLabel,
            seasonButtonStackView,
            seasonLabelStackView,
            seasonExplainLabel,
            sexLabel,
            sexButtonStackView,
            wommanLabel,
            uniSexLabel,
            manLabel,
            sexExplainLabel,
            ageLabel,
            ageResetButton,
            ageSlider,
            minAgeLabel,
            averageAgeLabel,
            maxAgeLabel,
            evaluatedAgeView,
            dragLabel
        ].forEach { addSubview($0) }
        
    }
    
    private func setConstraints() {
        seasonLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.trailing.equalToSuperview()
        }
        
        seasonButtonStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(seasonLabel.snp.bottom).offset(22)
            make.width.equalTo(256)
            make.height.equalTo(80)
        }
        
        seasonLabelStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(seasonButtonStackView.snp.bottom).offset(16)
        }
        
        seasonExplainLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(30)
            make.top.equalTo(seasonLabelStackView.snp.bottom).offset(16)
        }
        
        sexLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(seasonLabelStackView.snp.bottom).offset(40)
            make.trailing.equalToSuperview()
        }
        
        sexButtonStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(sexLabel.snp.bottom).offset(22)
            make.height.equalTo(80)
            make.width.equalTo(236)
        }
        
        wommanLabel.snp.makeConstraints { make in
            make.centerX.equalTo(womanButton.snp.centerX)
            make.top.equalTo(sexButtonStackView.snp.bottom).offset(9)
        }
        
        uniSexLabel.snp.makeConstraints { make in
            make.centerX.equalTo(uniSexButton.snp.centerX)
            make.top.equalTo(wommanLabel)
        }
        
        manLabel.snp.makeConstraints { make in
            make.centerX.equalTo(manButton.snp.centerX)
            make.top.equalTo(wommanLabel)
        }
        
        sexExplainLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(30)
            make.top.equalTo(wommanLabel.snp.bottom).offset(16)
        }
        
        ageLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(wommanLabel.snp.bottom).offset(48)
        }
        
        ageResetButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(34)
            make.top.equalTo(ageLabel.snp.top).offset(4)
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
        
        dragLabel.snp.makeConstraints { make in
            make.top.equalTo(ageLabel.snp.bottom).offset(34)
            make.leading.equalTo(ageLabel.snp.trailing).offset(39)
        }
    }
    
    func bind(reactor: EvaluationReactor) {
        // TODO: - 자기가 투표한 항목 리턴으로 수정 되면 delete 구현
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
            womanButton.rx.tap.map { 2 },
            uniSexButton.rx.tap.map { 3 }
            )
        .map { Reactor.Action.didTapGenderButton($0) }
        .bind(to: reactor.action)
        .disposed(by: disposeBag)
        
        // 나이 리셋 버튼 터치
        ageResetButton.rx.tap
            .map { Reactor.Action.didTapAgeResetButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // weather 평가 값 계절 버튼에 binding
        reactor.state
            .map { $0.weather }
            .compactMap { $0 }
            .map { [$0.spring, $0.summer, $0.autumn, $0.winter] }
            .bind(with: self) { owner, values in
                owner.setVerticalButtonBackgroundColor(owner.seasonButtons, values)
            }
            .disposed(by: disposeBag)
        
        // TODO: - 중성 값 리턴 후 다시 하기
        // gender 평가 값 binding
        reactor.state
            .map { $0.gender }
            .compactMap { $0 }
            .map { [$0.man, 50, $0.woman]}
            .bind(with: self) { owner, values in
                owner.setVerticalButtonBackgroundColor(owner.sexButtons, values)
            }
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
            .bind(with: self) { owner, value in
                if value != 0 {
                    let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
                    feedbackGenerator.impactOccurred()
                    owner.dragLabel.isHidden = true
                }
                
                else {
                    owner.dragLabel.isHidden = false
                }
            }
            .disposed(by: disposeBag)
        
        // age 평가 값 binding
        reactor.state
            .map { $0.age }
            .compactMap { $0 }
            .bind(onNext: setAgeSliderColor)
            .disposed(by: disposeBag)
        
        
        // TODO: - 리셋 api 연동하기
        // age reset ui 설정
        reactor.state
            .map { $0.isTapAgeReset }
            .distinctUntilChanged()
            .filter { $0 }
            .bind(with: self) { owner, _ in
                owner.ageSlider.isHidden = false
                owner.averageAgeLabel.text = ""
                owner.ageSlider.value = 0
                owner.evaluatedAgeView.isHidden = true
                owner.ageResetButton.isHidden = true
            }
            .disposed(by: disposeBag)
        
    }
}

extension EvaluationCell {
    
    // ageSlider 배경색, 텍스트 설정
    private func setAgeSliderColor(_ age: Age) {
        dragLabel.isHidden = true
        ageSlider.isHidden = true
        evaluatedAgeView.isHidden = false
        ageResetButton.isHidden = false
    
        let percent = CGFloat(age.age) / 50.0
        
        if age.age == 50 {
            evaluatedAgeView.layer.sublayers?[0].maskedCorners = allCornerRadius
        }
    
        evaluatedAgeView.layer.sublayers?[0].frame = CGRect(x: 0, y: 0, width: (UIScreen.main.bounds.width - 64) * percent, height: 52)
        
        averageAgeLabel.text = "평균 \(age.age)세"
        
    }
    
    // 막대 버튼 배경색, 텍스트 설정
    private func setVerticalButtonBackgroundColor(_ buttons: [UIButton], _ values: [Int]) {
        
        let count = values.count
        var isChangedTitleColor = [Bool](repeating: false, count: count)
        var isChangedImageColor = [Bool](repeating: false, count: count)
        let originalImage = buttons.map { $0.configuration?.image }
        
        for (index, value) in values.enumerated() {
            
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
        
        lazy var blackAgeLayer = CALayer()
        
        lazy var frame = evaluatedAgeView.frame
        
        blackAgeLayer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        
        blackAgeLayer.frame = CGRect(x: 0, y: 0, width: 0, height: 52)
        
        blackAgeLayer.cornerRadius = 5
        blackAgeLayer.backgroundColor = UIColor.black.cgColor
    
        evaluatedAgeView.layer.insertSublayer(blackAgeLayer, at: 0)
    }
    
    private func setVerticalBlackLayer() -> CALayer {
        let blackLayer = CALayer()
        blackLayer.frame = CGRect(x: 0, y: 80, width: 52, height: 0)
        blackLayer.backgroundColor = UIColor.black.cgColor
        blackLayer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        blackLayer.cornerRadius = 5
        
        return blackLayer
    }
}
