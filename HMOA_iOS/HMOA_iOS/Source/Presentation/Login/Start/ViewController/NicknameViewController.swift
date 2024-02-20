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
import ReactorKit

class NicknameViewController: UIViewController, View {
    
    //MARK: - Properties
    
    private lazy var nicknameView = NicknameView("다음")
    
    var disposeBag = DisposeBag()
    
    //MARK: - Init
    init(reactor: NicknameReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        setAddView()
        setConstraints()
        
    }
    
    override func viewDidLayoutSubviews() {
        super .viewDidLayoutSubviews()
        
        let frame = nicknameView.nicknameTextField.frame
        setBottomBorder(nicknameView.nicknameTextField,
                        width: frame.width,
                        height: frame.height)
    }
    
    //MARK: - SetUp
    
    private func setUpUI() {
        view.backgroundColor = .white
        setBackItemNaviBar("1/2")
    }
    
    private func setAddView() {
        view.addSubview(nicknameView)
    }
    
    private func setConstraints() {
        nicknameView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    
    //MARK: - Bind
    
    func bind(reactor: NicknameReactor) {
        //Input
        
        // 닉네임 textfiled 입력 이벤트
        nicknameView.nicknameTextField.rx.text
            .orEmpty
            .map { NicknameReactor.Action.didBeginEditingNickname($0)}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        //중복확인 터치 이벤트
        nicknameView.duplicateCheckButton.rx.tap
            .map { NicknameReactor.Action.didTapDuplicateButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        //다음 버튼 터치 이벤트
        nicknameView.bottomButton.rx.tap
            .map { NicknameReactor.Action.didTapStartButton}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        //textfield return 터치 이벤트
        nicknameView.nicknameTextField.rx.controlEvent(.editingDidEndOnExit)
            .map { NicknameReactor.Action.didTapTextFieldReturn}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        //닉네임 캡션 라벨 변경
        reactor.state
            .map { $0.isDuplicate }
            .compactMap { $0 }
            .asDriver(onErrorRecover: { _ in .empty() })
            .drive(with: self, onNext: { owner, isDuplicate in
                owner.changeCaptionLabelColor(isDuplicate)
            }).disposed(by: disposeBag)
        
        //버튼 enable 상태 변경
        reactor.state
            .map { $0.isEnable }
            .distinctUntilChanged()
            .compactMap { $0 }
            .asDriver(onErrorRecover: { _ in .empty() })
            .drive(with: self, onNext: { owner, isEnable in
                owner.changeNextButtonEnable(isEnable)
            }).disposed(by: disposeBag)
        
        //return 터치 시 키보드 내리기
        reactor.state
            .map { $0.isTapReturn }
            .distinctUntilChanged()
            .filter { $0 }
            .asDriver(onErrorRecover: { _ in .empty() })
            .drive(with: self, onNext: { owner, _ in
                owner.view.endEditing(true)
            }).disposed(by: disposeBag)
        
        //연도 VC로 화면 전환
        reactor.state
            .map { $0.isPushNextVC }
            .distinctUntilChanged()
            .filter { $0 }
            .asDriver(onErrorRecover: { _ in .empty() })
            .drive(with: self, onNext: { owner, _ in
                let vc = UserInformationViewController(nickname: reactor.currentState.nickname!, reactor: UserInformationReactor(service: UserYearService()))
                owner.navigationController?.pushViewController(vc,animated: true)
            }).disposed(by: disposeBag)
        
        // 닉네임 길이 제한
        reactor.state
            .map { $0.nickname }
            .compactMap { $0 }
            .map { text in
                if text.count > 8 {
                    let index = text.index(text.startIndex, offsetBy: 8)
                    return String(text[..<index])
                } else {
                    return text
                }
            }
            .asDriver(onErrorRecover: { _ in .empty() })
            .drive(with: self, onNext: { owner, text in
                owner.nicknameView.nicknameTextField.text = text
                owner.nicknameView.nicknameCountLabel.text = "\(text.count)/8"
            })
            .disposed(by: disposeBag)
            
    }
    
}

extension NicknameViewController {
    
    //MARK: - Functions
    
    //caption ui 변경
    private func changeCaptionLabelColor(_ isDuplicate: Bool) {
        if isDuplicate {
            nicknameView.nicknameCaptionLabel.text = "사용할 수 없는 닉네임 입니다."
            nicknameView.nicknameCaptionLabel.textColor = .customColor(.red)
        } else if !isDuplicate {
            nicknameView.nicknameCaptionLabel.text = "사용할 수 있는 닉네임 입니다."
            nicknameView.nicknameCaptionLabel.textColor = .customColor(.blue)
        }
    }
    
    //다음 버튼 ui변경
    private func changeNextButtonEnable(_ isEnable: Bool) {
        if isEnable  {
            self.nicknameView.bottomButton.isEnabled = true
            self.nicknameView.bottomButton.backgroundColor = .black
        } else {
            self.nicknameView.bottomButton.isEnabled = false
            self.nicknameView.bottomButton.backgroundColor = .customColor(.gray2)
        }
    }
    
    //빈 화면 터치 시 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
          self.view.endEditing(true)
    }
}
