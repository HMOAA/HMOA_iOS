//
//  NoLoginView.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/08/07.
//

import UIKit

import Then
import SnapKit
import RxCocoa

class NoLoginView: UIView {

    //MARK: - Properites
    
    
    //MARK: - UIComponents
    let titleLabel = UILabel().then {
        $0.numberOfLines = 2
        $0.setLabelUI(
"""
로그인이 필요한
페이지 입니다
""",
                      font: .pretendard_medium,
                      size: 42,
                      color: .black)
    }
     
    let explainLabel = UILabel().then {
        $0.numberOfLines = 2
        $0.setLabelUI(
"""
향모아의 회원이 되면
더 많은 기능을 사용할 수 있어요
""",
                      font: .pretendard,
                      size: 16,
                      color: .black)
    }
    
    let goLoginLabel = UILabel().then {
        $0.setLabelUI("로그인 바로가기", font: .pretendard_light, size: 16, color: .black)
    }
    
    let goLoginButton = UIButton().then {
        $0.setImage(UIImage(named: "rightArrow"), for: .normal)
    }
    
    //MARK: - LifeCycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAddView()
        setConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - SetUp
    
    private func setAddView() {
        [
            titleLabel,
            explainLabel,
            goLoginLabel,
            goLoginButton
        ] .forEach { addSubview($0) }
    }
    
    private func setConstraints() {
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(126)
            make.leading.equalToSuperview().inset(16)
        }
        
        explainLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.equalTo(titleLabel)
        }
        
        goLoginLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(explainLabel.snp.bottom).offset(40)
        }
        
        goLoginButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.top.equalTo(explainLabel.snp.bottom).offset(40)
        }
        
    }

}
