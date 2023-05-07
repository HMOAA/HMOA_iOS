//
//  NicknameView.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/05/07.
//

import UIKit
import SnapKit
import Then

class NicknameView: UIView {
    
    let nicknameLabel = UILabel().then {
        $0.setLabelUI("닉네임", font: .pretendard_medium, size: 14, color: .gray4)
    }
    
    let nicknameHorizontalStackView = UIStackView().then {
        $0.setStackViewUI(spacing: 8, axis: .horizontal)
    }
    
    lazy var nicknameTextField = UITextField().then {
        $0.setTextFieldUI("닉네임을 입력하세요", leftPadding: 16, font: .pretendard_light, isCapsule: false)
    }
    
    lazy var duplicateCheckButton = UIButton().then {
        $0.layer.cornerRadius = 5
        $0.setTitle("중복확인", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .black
        $0.titleLabel?.font = .customFont(.pretendard_light, 14)
    }
    
    let nicknameCaptionLabel = PaddingLabel().then {
        $0.setLabelUI("닉네임 제한 캡션입니다.", font: .pretendard_light, size: 12, color: .gray4)
    }
    
    lazy var bottomButton = UIButton().then {
        $0.isEnabled = false
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .customColor(.gray2)
        $0.titleLabel?.font = .customFont(.pretendard, 20)
    }
    
    init(_ bottomButtonTitle: String) {
        super.init(frame: .zero)
        self.bottomButton.setTitle(bottomButtonTitle, for: .normal)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NicknameView {
    
    func configureUI() {
        
        
        [   nicknameTextField,
            duplicateCheckButton
        ]   .forEach { nicknameHorizontalStackView.addArrangedSubview($0) }
        
        [   nicknameLabel,
            nicknameHorizontalStackView,
            nicknameCaptionLabel,
            bottomButton
        ]   .forEach { addSubview($0) }
        
        nicknameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(36)
            $0.leading.equalToSuperview().inset(16)
        }
        
        duplicateCheckButton.snp.makeConstraints {
            $0.width.equalTo(80)
            $0.height.equalTo(46)
        }
        
        nicknameHorizontalStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(6)
        }
        
        nicknameCaptionLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameHorizontalStackView.snp.bottom).offset(8)
            $0.leading.equalToSuperview().inset(32)
        }
        
        bottomButton.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(80)
        }
    }
}


