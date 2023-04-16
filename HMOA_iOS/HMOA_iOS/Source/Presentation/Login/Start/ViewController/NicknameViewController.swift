//
//  NicknameViewController.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/03/21.
//

import UIKit

import Then
import SnapKit
import RxCocoa
import RxSwift

class NicknameViewController: UIViewController {
    
    //MARK: - Property
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
        $0.setTitle("다음", for: .normal)
    }
    
    let disposeBag = DisposeBag()
    let reactor = NicknameReactor()
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        setAddView()
        setConstraints()
        bind(reactor: reactor)
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
    
    //MARK: - Bind
    private func bind(reactor: NicknameReactor) {
        //Input
        
        //중복확인 터치 이벤트
        duplicateCheckButton.rx.tap
            .map { NicknameReactor.Action.didTapDuplicateButton(self.nicknameTextField.text?.isEmpty)}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        //다음 버튼 터치 이벤트
        nextButton.rx.tap
            .map { NicknameReactor.Action.didTapStartButton}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        nicknameTextField.rx.controlEvent(.editingDidEndOnExit)
            .map { NicknameReactor.Action.didTapTextFieldReturn}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        //닉네임 캡션 라벨 변경
        reactor.state
            .map { $0.isDuplicate}
            .distinctUntilChanged()
            .compactMap { $0 }
            .bind(onNext: { isDuplicate in
                self.changeCaptionLabelColor(isDuplicate)
            }).disposed(by: disposeBag)
        
        //버튼 enable 상태 변경
        reactor.state
            .map { $0.isEnable }
            .distinctUntilChanged()
            .compactMap { $0 }
            .bind(onNext: { isEnable in
                
                self.changeNextButtonEnable(isEnable)
            }).disposed(by: disposeBag)
        
        //StartVC로 이동
        reactor.state
            .map { $0.isPush }
            .distinctUntilChanged()
            .filter { $0 }
            .bind(onNext: { _ in
                self.navigationController?.pushViewController(UserInformationViewController(), animated: true)
            }).disposed(by: disposeBag)
        
        //return 터치 시 키보드 내리기
        reactor.state
            .map { $0.isTapReturn }
            .distinctUntilChanged()
            .filter { $0 }
            .bind(onNext: { _ in
                self.nicknameTextField.resignFirstResponder()
            }).disposed(by: disposeBag)
    }
    
}

extension NicknameViewController {
    
    //MARK: - Functions
    
    //caption ui 변경
    private func changeCaptionLabelColor(_ isDuplicate: Bool) {
        if isDuplicate {
            nicknameCaptionLabel.text = "사용할 수 없는 닉네임 입니다."
            nicknameCaptionLabel.textColor = .customColor(.red)
        } else {
            nicknameCaptionLabel.text = "사용할 수 있는 닉네임 입니다."
            nicknameCaptionLabel.textColor = .customColor(.blue)
        }
    }
    
    //다음 버튼 ui변경
    private func changeNextButtonEnable(_ isEnable: Bool) {
        if isEnable  {
            self.nextButton.isEnabled = true
            self.nextButton.backgroundColor = .black
        } else {
            self.nextButton.isEnabled = false
            self.nextButton.backgroundColor = .customColor(.gray2)
        }
    }
    
    //빈 화면 터치 시 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
          self.view.endEditing(true)
    }
}
