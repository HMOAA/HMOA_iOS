//
//  ChangeSexViewController.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/03/31.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then
import ReactorKit

class ChangeSexViewController: UIViewController, View {
    
    //MARK: - Property
    
    typealias Reactor = ChangeSexReactor
    var disposeBag = DisposeBag()
    
    // MARK: - UI Component
    
    let sexStackView = UIStackView().then {
        $0.setStackViewUI(spacing: 16, axis: .horizontal)
    }
    
    lazy var womanButton = UIButton(configuration: configureButton("여성")).then {
        $0.setImage(UIImage(named: "circle"), for: .normal)
        $0.setImage(UIImage(named: "selectCircle"), for: .selected)
    }
    
    lazy var manButton = UIButton(configuration: configureButton("남성")).then {
        $0.setImage(UIImage(named: "circle"), for: .normal)
        $0.setImage(UIImage(named: "selectCircle"), for: .selected)
    }
    
    lazy var changeButton = UIButton().then {
        $0.isEnabled = false
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .customColor(.gray2)
        $0.titleLabel?.font = .customFont(.pretendard, 20)
        $0.setTitle("변경", for: .normal)
    }
        
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackItemNaviBar("성별")
        setUpUI()
        setAddView()
        setUpConstraints()
    }
    
    //MARK: - SetUp
    private func setUpUI() {
        view.backgroundColor = .white
    }
    
    private func configureButton(_ title: String) -> UIButton.Configuration {
        var config = UIButton.Configuration.plain()
        
        var titleAttr = AttributedString.init(title)
        titleAttr.font = .customFont(.pretendard, 16)
        titleAttr.foregroundColor = .black
        
        config.baseBackgroundColor = .white
        config.imagePadding = 12
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        config.attributedTitle = titleAttr
        
        return config
    }
    
    private func setAddView() {
        [
            womanButton,
            manButton
        ].forEach { sexStackView.addArrangedSubview($0) }
        
        [
            sexStackView,
            changeButton
        ].forEach { view.addSubview($0) }
    }
    
    private func setUpConstraints() {
        
        sexStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(36)
        }
        
        changeButton.snp.makeConstraints { make in
            make.height.equalTo(80)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    //MARK: - Bind
    func bind(reactor: Reactor) {
        //Input
        
        //여성 버튼 터치 이벤트
        womanButton.rx.tap
            .map { Reactor.Action.didTapWomanButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        //남성 버튼 터치 이벤트
        manButton.rx.tap
            .map { Reactor.Action.didTapManButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        //변경 버튼 터치 이벤트
        changeButton.rx.tap
            .map { Reactor.Action.didTapChangeButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        //OutPut
        
        //woman 버튼 활성화
        reactor.state
            .map { $0.isCheckedWoman }
            .distinctUntilChanged()
            .bind(to: self.womanButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        //man 버튼 활성화
        reactor.state
            .map { $0.isCheckedMan }
            .distinctUntilChanged()
            .bind(to: self.manButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        //성별 버튼 활성화 체크 및 UI 업데이트
        reactor.state
            .map { $0.isSexCheck }
            .distinctUntilChanged()
            .filter { $0 }
            .bind(onNext: { _ in
                self.setEnableChangeButton()
            }).disposed(by: disposeBag)
        
        //MyPage로 pop
        reactor.state
            .map { $0.isPopMyPage }
            .distinctUntilChanged()
            .filter { $0 }
            .bind(onNext: { _ in
                self.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
    }
}

extension ChangeSexViewController {
    
    //MARK: - Functions
    
    //ChangeButton UI 변경
    func setEnableChangeButton() {
        changeButton.backgroundColor = .black
        changeButton.isEnabled = true
    }

}
