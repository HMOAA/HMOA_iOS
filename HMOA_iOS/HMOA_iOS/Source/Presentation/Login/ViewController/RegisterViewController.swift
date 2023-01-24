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
    
    lazy var entireStackView = UIStackView().then {
        setStackView($0, spacing: 29)
    }
    
    lazy var nameStackView = UIStackView().then {
        setStackView($0, spacing: 7)
    }
    lazy var nameLabel = UILabel().then {
        setLabel($0, "이름")
    }
    lazy var nameTextField = UITextField().then {
        setTextField($0, "이름")
    }
    
    lazy var idStackView = UIStackView().then {
        setStackView($0, spacing: 7)
    }
    lazy var idLabel = UILabel().then {
        setLabel($0, "아이디")
    }
    lazy var idHorizontalStackView = UIStackView().then {
        setStackView($0, spacing: 9, axis: .horizontal)
    }
    lazy var idTextField = UITextField().then {
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        setTextField($0, "아이디")
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
        setStackView($0, spacing: 7)
    }
    lazy var pwLabel = UILabel().then {
        setLabel($0, "비밀번호")
    }
    lazy var pwTextField = UITextField().then {
        setTextField($0, "비밀번호 (영어소문자+숫자 8자리 이상)")
    }
    
    lazy var pwCheckStackView = UIStackView().then {
        setStackView($0, spacing: 7)
    }
    lazy var pwCheckLabel = UILabel().then {
        setLabel($0, "비밀빈허 재확인")
    }
    lazy var pwCheckTextField = UITextField().then {
        setTextField($0, "비밀번호 재확인")
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
    
    private func setTextField(_ textField: UITextField, _ placeholder: String) {
        textField.backgroundColor = .customColor(.searchBarColor)
        textField.font = .customFont(.pretendard, 14)
        textField.placeholder = placeholder
        textField.addLeftPadding(14)
        textField.setPlaceholder(color: .black)

        textField.snp.makeConstraints { make in
            make.height.equalTo(33)
        }
        textField.layer.cornerRadius = 33 / 2
        
    }
    
    private func setLabel(_ label: UILabel, _ text: String) {
        label.font = .customFont(.pretendard, 14)
        label.text = text
    }
    
    private func setStackView(_ stackView: UIStackView, spacing: CGFloat, axis: NSLayoutConstraint.Axis = .vertical) {
        stackView.distribution = .fill
        stackView.spacing = spacing
        stackView.axis = axis
    }
    
    //MARK: - Function
    @objc func didTapRegisterButton(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
