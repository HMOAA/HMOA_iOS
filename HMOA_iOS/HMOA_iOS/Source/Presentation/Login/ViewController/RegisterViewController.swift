//
//  RegisterViewController.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/01/24.
//

import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

class RegisterViewController: UIViewController {
    
    //MARK: - Property
    
    let entireStackView = UIStackView().then {
        $0.setStackViewUI(spacing: 24)
    }
    
    let nicknameStackView = UIStackView().then {
        $0.setStackViewUI(spacing: 8)
    }
    let nicknameLabel = UILabel().then {
        $0.setLabelUI("닉네임", font: .pretendard_medium, size: 14, color: .gray4)
    }
    let nicknameTextField = UITextField().then {
        $0.setTextFieldUI("닉네임을 입력하세요", leftPadding: 16, font: .pretendard_light, isCapsule: false)
    }
    let nicknameCaptionLabel = PaddingLabel().then {
        $0.setLabelUI("닉네임 제한 캡션입니다.", font: .pretendard_light, size: 12, color: .gray4)
    }
    
    let idStackView = UIStackView().then {
        $0.setStackViewUI(spacing: 8)
    }
    let idLabel = UILabel().then {
        $0.setLabelUI("아이디", font: .pretendard_medium, size: 14, color: .gray4)
    }
    let idHorizontalStackView = UIStackView().then {
        $0.setStackViewUI(spacing: 8, axis: .horizontal)
    }
    let idTextField = UITextField().then {
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        $0.setTextFieldUI("아이디를 입력하세요", leftPadding: 16, font: .pretendard_light, isCapsule: false)
    }
    let duplicateCheckButton = UIButton().then {
        $0.layer.cornerRadius = 5
        $0.setTitle("중복확인", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .black
        $0.titleLabel?.font = .customFont(.pretendard_light, 14)
    }
    let idCaptionLabel = PaddingLabel().then {
        $0.setLabelUI("아이디 제한 캡션입니다.", font: .pretendard_light, size: 12, color: .gray4)
    }
    
    let emailStackView = UIStackView().then {
        $0.setStackViewUI(spacing: 8)
    }
    let emailLabel = UILabel().then {
        $0.setLabelUI("이메일", font: .pretendard_medium, size: 14, color: .gray4)
    }
    let emailHorizontalView = UIView()
    let emailTextField = UITextField().then {
        $0.setTextFieldUI("이메일", leftPadding: 16, font: .pretendard_light, isCapsule: false)
    }
    let atLabel = UILabel().then {
        $0.snp.contentHuggingHorizontalPriority = 251
        $0.setLabelUI("@", font: .pretendard_light, size: 14, color: .gray4)
    }
    
    let choiceHorizhontalView = UIView()
    let choiceTextField = UITextField().then {
        $0.isUserInteractionEnabled = false
        $0.setTextFieldUI("선택", leftPadding: 0, font: .pretendard_light)
        $0.textColor = .customColor(.gray3)
    }
    let emailChoiceButton = UIButton().then {
        $0.tintColor = .customColor(.gray2)
        $0.setImage(UIImage(named: "choiceDown"), for: .normal)
    }
    let emailCaption = PaddingLabel().then {
        $0.setLabelUI("비밀번호와 아이디 분실시, 이메일을 이용해 찾을 수 있습니다.", font: .pretendard_light, size: 12, color: .gray4)
    }

    let nextButton = UIButton().then {
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .customFont(.pretendard_medium, 20)
        $0.backgroundColor = .customColor(.gray2)
        $0.setTitle("다음", for: .normal)
    }
    
    let disposeBag = DisposeBag()
    let registerReactor = RegisterReactor()
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        setAddView()
        setUpConstraints()
        
        bind(reactor: registerReactor)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        [emailTextField, idTextField, nicknameTextField, choiceHorizhontalView].forEach {
            setBottomBorder($0, width: $0.frame.width, height: $0.frame.height)
        }
    }
    
    //MARK: - SetUp

    private func setUpUI() {
        view.backgroundColor = .white
        
        setNavigationBarTitle(title: "회원가입", color: .white, isHidden: false, isScroll: false)
    }
    
    private func setAddView() {
        [nicknameLabel, nicknameTextField, nicknameCaptionLabel].forEach { nicknameStackView.addArrangedSubview($0) }
        
        [idTextField, duplicateCheckButton].forEach { idHorizontalStackView.addArrangedSubview($0) }
        [idLabel, idHorizontalStackView, idCaptionLabel].forEach { idStackView.addArrangedSubview($0) }
        
        [choiceTextField, emailChoiceButton].forEach { choiceHorizhontalView.addSubview($0) }
        [emailTextField, atLabel, choiceHorizhontalView].forEach { emailHorizontalView.addSubview($0) }
    
        
        [emailLabel, emailHorizontalView, emailCaption].forEach { emailStackView.addArrangedSubview($0) }
        
        [nicknameStackView, idStackView, emailStackView].forEach { entireStackView.addArrangedSubview($0)}
        
        [entireStackView, nextButton].forEach { view.addSubview($0)}
        
    }
    
    private func setUpConstraints() {
        
        atLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview()
            make.trailing.equalTo(atLabel.snp.leading).offset(5)
        }
        
        emailChoiceButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
        
        choiceTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        choiceHorizhontalView.snp.makeConstraints { make in
            make.leading.equalTo(atLabel.snp.trailing).offset(5)
            make.top.bottom.trailing.equalToSuperview()
        }
        
        entireStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(36)
        }
        
        
        duplicateCheckButton.snp.makeConstraints { make in
            make.width.equalTo(80)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(80)
            make.leading.trailing.bottom.equalToSuperview()
        }
    
        [emailHorizontalView, nicknameTextField, idHorizontalStackView].forEach {
            $0.snp.makeConstraints { make in
                make.height.equalTo(46)
            }
        }
        
        [emailCaption, idCaptionLabel, nicknameCaptionLabel].forEach {
            $0.setPadding(padding: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0))
        }
        
        
    
    }
       
    //MARK: - Function
   
    
    
    private func setChoiceTextField(_ email: String) {
        
        choiceTextField.textColor = .black
        if email == "직접입력" {
            choiceTextField.isUserInteractionEnabled = true
            choiceTextField.placeholder = email
            choiceTextField.text = ""
        } else {
            choiceTextField.text = email
            choiceTextField.isUserInteractionEnabled = false
        }
    }
    
    private func bind(reactor: RegisterReactor) {
        //Input
        nextButton.rx.tap
            .map { RegisterReactor.Action.didTapNextButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        emailChoiceButton.rx.tap
            .map { RegisterReactor.Action.didTapEmailChoiceButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        //Output
        reactor.state
            .map { $0.isPush }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { isPush in
                if isPush{
                    self.navigationController?
                        .pushViewController(PwRegisterViewController(), animated: true)
                }
            }).disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isPresent }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { isPresent in
                if isPresent {
                    let vc = ChoiceEmailViewController()
                    vc.modalPresentationStyle = .pageSheet
                    
                    if let sheet = vc.sheetPresentationController {
                        sheet.detents = [.medium()]
                        sheet.largestUndimmedDetentIdentifier = .medium
                    }
                    
                    self.present(vc, animated: true)
                }
            }).disposed(by: disposeBag)
        
        
    }
}

