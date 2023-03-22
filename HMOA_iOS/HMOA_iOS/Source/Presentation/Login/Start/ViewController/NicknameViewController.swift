//
//  NicknameViewController.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/03/21.
//

import UIKit

class NicknameViewController: UIViewController {
    
    //MAKR: - Property
    
    let nicknameLabel = UILabel().then {
        $0.setLabelUI("닉네임", font: .pretendard_medium, size: 14, color: .gray4)
    }
    
    let nicknameHorizontalStackView = UIStackView().then {
        $0.setStackViewUI(spacing: 8, axis: .horizontal)
    }
    let nicknameTextField = UITextField().then {
        $0.setTextFieldUI("닉네임을 입력하세요", leftPadding: 16, font: .pretendard_light, isCapsule: false)
    }
    let duplicateCheckButton = UIButton().then {
        $0.layer.cornerRadius = 5
        $0.setTitle("중복확인", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .black
        $0.titleLabel?.font = .customFont(.pretendard_light, 14)
    }
    
    let nicknameCaptionLabel = PaddingLabel().then {
        $0.setLabelUI("닉네임 제한 캡션입니다.", font: .pretendard_light, size: 12, color: .gray4)
    }
    
    let nextButton = UIButton().then {
        $0.isEnabled = false
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .customColor(.gray2)
        $0.titleLabel?.font = .customFont(.pretendard, 20)
        $0.setTitle("시작하기", for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        setAddView()
        setConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super .viewDidLayoutSubviews()
        
        let frame = nicknameTextField.frame
        setBottomBorder(nicknameTextField,
                        width: frame.width,
                        height: frame.height)
    }
    
    //MARK: - SetUp
    private func setUpUI() {
        view.backgroundColor = .white
        setNavigationBarTitle(title: "1/2", color: .white, isHidden: false, isScroll: false)
    }
    private func setAddView() {
        [nicknameTextField,
         duplicateCheckButton
        ].forEach { nicknameHorizontalStackView.addArrangedSubview($0) }
        
        [nicknameLabel,
         nicknameHorizontalStackView,
         nicknameCaptionLabel,
         nextButton
        ].forEach { view.addSubview($0) }
    }
    
    private func setConstraints() {
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(36)
            make.leading.equalToSuperview().inset(16)
        }
        
        duplicateCheckButton.snp.makeConstraints { make in
            make.width.equalTo(80)
            make.height.equalTo(46)
        }
        
        nicknameHorizontalStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(nicknameLabel.snp.bottom).offset(6)
        }
        
        nicknameCaptionLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameHorizontalStackView.snp.bottom).offset(8)
            make.leading.equalToSuperview().inset(32)
        }
        
        nextButton.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(80)
        }
    }
}
