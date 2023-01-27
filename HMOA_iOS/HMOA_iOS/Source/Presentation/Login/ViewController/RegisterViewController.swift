//
//  RegisterViewController.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/01/24.
//

import UIKit

import SnapKit
import Then

class RegisterViewController: UIViewController {
    
    //Property
    let registerLabel = UILabel().then {
        $0.textAlignment = .center
        $0.backgroundColor = .customColor(.searchBarColor)
        $0.font = .customFont(.pretendard, 16)
        $0.text = "회원가입"
    }
    
    let entireStackView = UIStackView().then {
        $0.setStackViewUI(spacing: 29)
    }
    
    let nameStackView = UIStackView().then {
        $0.setStackViewUI(spacing: 7)
    }
    let nameLabel = UILabel().then {
        $0.setLabelUI("이름")
    }
    let nameTextField = UITextField().then {
        $0.setTextFieldUI("이름", leftPadding: 14)
    }
    
    let idStackView = UIStackView().then {
        $0.setStackViewUI(spacing: 7)
    }
    let idLabel = UILabel().then {
        $0.setLabelUI("아이디")
    }
    let idHorizontalStackView = UIStackView().then {
        $0.setStackViewUI(spacing: 9, axis: .horizontal)
    }
    let idTextField = UITextField().then {
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        $0.setTextFieldUI("아이디", leftPadding: 14)
    }
    
    let duplicateCheckButton = UIButton().then {
        $0.layer.cornerRadius = 33 / 2
        $0.setTitle("  중복확인", for: .normal)
        $0.contentHorizontalAlignment = .left
        $0.setTitleColor(.black, for: .normal)
        $0.backgroundColor = .customColor(.searchBarColor)
        $0.titleLabel?.font = .customFont(.pretendard, 14)
    }
    
    lazy var pwStackView = UIStackView().then {
        $0.setStackViewUI(spacing: 7)
    }
    let pwLabel = UILabel().then {
        $0.setLabelUI("비밀번호")
    }
    let pwTextField = UITextField().then {
        $0.setTextFieldUI("비밀번호 (영어소문자+숫자 8자리 이상)", leftPadding: 14)
    }
    
    lazy var pwCheckStackView = UIStackView().then {
        $0.setStackViewUI(spacing: 7)
    }
    let pwCheckLabel = UILabel().then {
        $0.setLabelUI("비밀빈호 재확인")
    }
    let pwCheckTextField = UITextField().then {
        $0.setTextFieldUI("비밀번호 재확인", leftPadding: 14)
    }
    
    let registerButton = UIButton().then {
        $0.setTitleColor(.black, for: .normal)
        $0.backgroundColor = .customColor(.searchBarColor)
        $0.titleLabel?.font = .customFont(.pretendard, 16)
        $0.setTitle("가입완료", for: .normal)
    }
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setAddView()
        setUpConstraints()
    }

    private func setUpUI() {
        view.backgroundColor = .white
        registerButton.addTarget(self, action: #selector(didTapRegisterButton(_: )), for: .touchUpInside)
    }
    
    private func setAddView() {
        [nameLabel, nameTextField].forEach { nameStackView.addArrangedSubview($0)}
        [idTextField, duplicateCheckButton].forEach { idHorizontalStackView.addArrangedSubview($0) }
        [idLabel, idHorizontalStackView].forEach { idStackView.addArrangedSubview($0)}
        [pwLabel, pwTextField].forEach { pwStackView.addArrangedSubview($0)}
        [pwCheckLabel, pwCheckTextField].forEach { pwCheckStackView.addArrangedSubview($0) }
        
        
        [nameStackView, idStackView, pwStackView, pwCheckStackView].forEach { entireStackView.addArrangedSubview($0)}
        
        [registerLabel, entireStackView, registerButton].forEach { view.addSubview($0) }
        
        
    }
    private func setUpConstraints() {
        duplicateCheckButton.snp.makeConstraints { make in
            make.width.equalTo(114)
        }
        
        registerLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(23)
            make.height.equalTo(42)
        }
        
        entireStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(registerLabel.snp.bottom).offset(16)
        }
        
        registerButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(66)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
       
    //MARK: - Function
    @objc func didTapRegisterButton(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
