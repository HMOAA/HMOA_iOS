//
//  EvaluationCell.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/08/01.
//

import UIKit

import Then
import SnapKit

class EvaluationCell: UICollectionViewCell {
    
    static let identifier = "EvaluationCell"
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
    let springButton = UIButton().then {
        $0.setImage(UIImage(named: "springButton"), for: .normal)
        $0.layer.cornerRadius = 5
    }
    let summerButton = UIButton().then {
        $0.setImage(UIImage(named: "summerButton"), for: .normal)
        $0.layer.cornerRadius = 5
    }
    let fallButton = UIButton().then {
        $0.setImage(UIImage(named: "fallButton"), for: .normal)
        $0.layer.cornerRadius = 5
    }
    let winterButton = UIButton().then {
        $0.setImage(UIImage(named: "winterButton"), for: .normal)
        $0.layer.cornerRadius = 5
    }
    
    let seasonLabelStackView = UIStackView().then {
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
        $0.layer.cornerRadius = 5
        $0.setImage(UIImage(named: "womanButton"), for: .normal)
    }
    let uniSexButton = UIButton().then {
        $0.layer.cornerRadius = 5
        $0.setImage(UIImage(named: "uniSexButton"), for: .normal)
    }
    let manButton = UIButton().then {
        $0.layer.cornerRadius = 5
        $0.setImage(UIImage(named: "manButton"), for: .normal)
    }
    
    let sexLabelStackView = UIStackView().then {
        $0.setStackViewUI(spacing: 95, axis: .horizontal)
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
    
    let maxAgeLabel = UILabel().then {
        $0.setLabelUI("50대 이상",
                      font: .pretendard,
                      size: 16,
                      color: .black)
    }
    
    
    
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        
        setAddView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - SetUp
    private func setAddView() {
        [
           springButton,
           summerButton,
           fallButton,
           winterButton
        ].forEach { seasonButtonStackView.addArrangedSubview($0) }
        
        [
            springLabel,
            summerLabel,
            fallLabel,
            winterLabel
        ].forEach { seasonLabelStackView.addArrangedSubview($0) }
        
        [
            wommanButton,
            uniSexButton,
            manButton
        ].forEach { sexButtonView.addSubview($0) }
        
        [
            wommanLabel,
            uniSexLabel,
            manLabel
        ].forEach { sexLabelStackView.addArrangedSubview($0) }
        
        [
            seasonLabel,
            seasonButtonStackView,
            seasonLabelStackView,
            sexLabel,
            sexButtonView,
            sexLabelStackView,
            ageLabel,
            ageSlider,
            minAgeLabel,
            maxAgeLabel
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
        
        sexLabelStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(sexButtonView.snp.bottom).offset(16)
            
        }
        
        ageLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalToSuperview()
            make.top.equalTo(sexLabelStackView.snp.bottom).offset(40)
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
        
        maxAgeLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(26)
            make.top.equalTo(ageSlider.snp.bottom).offset(16)
        }
    }
}
