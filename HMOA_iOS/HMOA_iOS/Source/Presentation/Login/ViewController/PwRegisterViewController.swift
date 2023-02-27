//
//  PwRegisterViewController.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/02/21.
//

import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

class PwRegisterViewController: UIViewController {
    
    //MARK: - Property
    let entireStackView = UIStackView().then {
        $0.setStackViewUI(spacing: 24)
    }
    
    let pwStackView = UIStackView().then {
        $0.setStackViewUI(spacing: 8)
    }
    let pwLabel = UILabel().then {
        $0.setLabelUI("비밀번호", font: .pretendard_medium, size: 14, color: .gray4)
    }
    let pwHorizontalView = UIView()
    let pwHiddenButton = UIButton().then {
        $0.setImage(UIImage(named: "noHidden"), for: .selected)
        $0.setImage(UIImage(named: "hidden"), for: .normal)
    }
    let pwTextField = UITextField().then {
        $0.setTextFieldUI("비밀번호", leftPadding: 16, font: .pretendard_light, isCapsule: false)
    }
    let pwCaptionLabel = PaddingLabel().then {
        $0.setLabelUI("비밀번호 제한 캡션입니다.", font: .pretendard_light, size: 12, color: .gray4)
    }
    
    let reConfirmPwStackView = UIStackView().then {
        $0.setStackViewUI(spacing: 8)
    }
    let reConfirmPwLabel = UILabel().then {
        $0.setLabelUI("비밀번호 재확인", font: .pretendard_medium, size: 14, color: .gray4)
    }
    let reConfirmPwHorizontalView = UIView()
    let reConfirmPwHiddenButton = UIButton().then {
        $0.setImage(UIImage(named: "noHidden"), for: .selected)
        $0.setImage(UIImage(named: "hidden"), for: .normal)
    }
    let reConfirmPwTextField = UITextField().then {
        $0.setTextFieldUI("비밀번호 재확인", leftPadding: 16, font: .pretendard_light, isCapsule: false)
    }
    let reConfirmPwCaptionLabel = PaddingLabel().then {
        $0.setLabelUI("설정한 비밀번호를 다시 입력해 재확인해주세요", font: .pretendard_light, size: 12, color: .gray4)
    }
    
    let registerButton = UIButton().then {
        $0.isEnabled = false
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .customFont(.pretendard_medium, 20)
        $0.backgroundColor = .customColor(.gray2)
        $0.setTitle("가입완료", for: .normal)
    }
    
    let viewModel = PwRegisetrViewModel()
    let disposeBag = DisposeBag()
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBarTitle(title: "회원가입", color: .white, isHidden: false, isScroll: false)
        setUpUI()
        setAddView()
        setUpConstraints()
        
        bind()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        [pwHorizontalView, reConfirmPwHorizontalView].forEach {
            self.setBottomBorder($0, width: $0.frame.width, height: $0.frame.height)
        }
    }
    
    //MARK: - SetUp
    private func setUpUI() {
        view.backgroundColor = .white
        pwCaptionLabel.setPadding(padding: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0))
        reConfirmPwCaptionLabel.setPadding(padding: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0))
    }
    
    private func setAddView() {
        [pwTextField, pwHiddenButton].forEach { pwHorizontalView.addSubview($0) }
        
        [reConfirmPwTextField, reConfirmPwHiddenButton].forEach { reConfirmPwHorizontalView.addSubview($0) }
        
        [pwLabel, pwHorizontalView, pwCaptionLabel].forEach { pwStackView.addArrangedSubview($0) }
        
        [reConfirmPwLabel, reConfirmPwHorizontalView, reConfirmPwCaptionLabel].forEach { reConfirmPwStackView.addArrangedSubview($0) }
        
        [pwStackView, reConfirmPwStackView].forEach { entireStackView.addArrangedSubview($0) }
        
        [entireStackView, registerButton].forEach { view.addSubview($0)}
    }
    
    private func setUpConstraints() {
        pwTextField.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
        }

        pwHiddenButton.snp.makeConstraints { make in
            make.leading.equalTo(pwTextField.snp.trailing)
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        reConfirmPwTextField.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
        }

        reConfirmPwHiddenButton.snp.makeConstraints { make in
            make.leading.equalTo(pwTextField.snp.trailing)
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        entireStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(36)
        }
        
        [pwTextField, reConfirmPwTextField].forEach {
            $0.snp.makeConstraints { make in
                make.height.equalTo(46)
            }
        }
        
        registerButton.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(80)
        }
    }
    
    //MARK: - Bind
    private func bind() {
        
        pwTextField.rx.text
            .orEmpty
            .bind(to: viewModel.pwTextOb)
            .disposed(by: disposeBag)
        
        reConfirmPwTextField.rx.text
            .orEmpty
            .bind(to: viewModel.reConfirmPwTextOb)
            .disposed(by: disposeBag)
        
        viewModel.moreThan8
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { result in
                result ? self.pwCaptionUpdate(.pwAvailable) : self.pwCaptionUpdate(.pwUnAvailable)
            }).disposed(by: disposeBag)
        
        viewModel.isSame
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { result in
                result ? self.pwCaptionUpdate(.reAvailable) : self.pwCaptionUpdate(.reUnAvailble)
            }).disposed(by: disposeBag)
        
        pwHiddenButton.rx.tap
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
                self.pwTextField.isSecureTextEntry.toggle()
                self.pwHiddenButton.isSelected.toggle()
            }).disposed(by: disposeBag)
        
        reConfirmPwHiddenButton.rx.tap
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
                self.reConfirmPwTextField.isSecureTextEntry.toggle()
                self.reConfirmPwHiddenButton.isSelected.toggle()
            }).disposed(by: disposeBag)
        
        registerButton.rx.tap
            .subscribe(onNext: {
                self.navigationController?
                    .pushViewController(StartViewController(), animated: true)
            }).disposed(by: disposeBag)
    }
    
    //MARK: UpdateUI
    func pwCaptionUpdate(_ state: PwTextFieldState) {
        switch state{
        case .pwAvailable:
            pwCaptionLabel.text = "사용할 수 있는 비밀번호입니다"
            pwCaptionLabel.textColor = .customColor(.blue)
        case .pwUnAvailable:
            pwCaptionLabel.text = "비밀번호 제한 캡션입니다"
            pwCaptionLabel.textColor = .customColor(.gray4)
        case .reAvailable:
            reConfirmPwCaptionLabel.text = "확인되었습니다"
            reConfirmPwCaptionLabel.textColor = .customColor(.blue)
            ableRegisterButton(true)
        case .reUnAvailble:
            reConfirmPwCaptionLabel.text = "비밀번호가 일치하지 않습니다"
            reConfirmPwCaptionLabel.textColor = .customColor(.red)
            ableRegisterButton(false)
        }
    }
    
    func ableRegisterButton(_ isEnabled: Bool) {
        if isEnabled {
            registerButton.backgroundColor = .black
            registerButton.isEnabled = true
        }
        else {
            registerButton.backgroundColor = .customColor(.gray2)
            registerButton.isEnabled = false
        }
    }
}
