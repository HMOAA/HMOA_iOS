//
//  QnAWriteViewController.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/09/11.
//

import UIKit

import Then
import SnapKit
import RxCocoa
import RxSwift
import ReactorKit

class QnAWriteViewController: UIViewController, View {

    var disposeBag = DisposeBag()
    
    //MARK: - UI Components
    
    let titleNaviLabel = UILabel().then {
        $0.font = .customFont(.pretendard_medium, 20)
        $0.textColor = .black
    }
    
    let cancleButton = UIButton().then {
        $0.setTitle("취소", for: .normal)
        $0.titleLabel?.font = .customFont(.pretendard, 16)
        $0.setTitleColor(.black, for: .normal)
        $0.tintColor = .black
    }
    
    let okButton = UIButton().then {
        $0.setTitle("확인", for: .normal)
        $0.titleLabel?.font = .customFont(.pretendard, 16)
        $0.setTitleColor(.black, for: .normal)
        $0.tintColor = .black
    }
    
    let titleView = UIView()
    
    let titleLabel = UILabel().then {
        $0.font = .customFont(.pretendard_light, 16)
        $0.text = "제목:"
        $0.textColor = .black
    }
    let titleTextField = UITextField().then {
        $0.font = .customFont(.pretendard, 14)
        $0.placeholder = "제목을 입력해주세요"
        $0.setPlaceholder(color: .customColor(.gray3))
    }
    
    let textView = UITextView()
    
    let addImageButton = UIBarButtonItem(
        image: UIImage(named: "addImageButton"),
        style: .plain,
        target: nil,
        action: nil)
    
    lazy var toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 34)).then {
        $0.tintColor = .black
        $0.sizeToFit()
        $0.items = [addImageButton]
    }
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setOkCancleNavigationBar(okButton: okButton, cancleButton: cancleButton, titleLabel: titleNaviLabel)
        setUpUI()
        setAddView()
        setConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        titleView.layer.addBorder([.top, .bottom], color: .black, width: 1)
    }
    
    //MARK: - SetUp
    private func setUpUI() {
        view.backgroundColor = .white
        textView.inputAccessoryView = toolBar
    }
    
    private func setAddView() {
        
        [
            titleLabel,
            titleTextField
        ]   .forEach { titleView.addSubview($0) }
        
        [
         titleView,
         textView,
         toolBar
        ].forEach { view.addSubview($0) }
    }
    
    private func setConstraints() {
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(32)
            make.centerY.equalToSuperview()
            make.width.equalTo(32)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(6)
            make.trailing.top.bottom.equalToSuperview()
        }
        
        titleView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(45)
        }
        
        textView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(32)
            make.top.equalTo(titleTextField.snp.bottom).offset(24)
            make.bottom.equalToSuperview()
        }
    }
    
    func bind(reactor: CommunityWriteReactor) {
        // Action
        
        // 확인 버튼 클릭
        okButton.rx.tap
            .map { Reactor.Action.didTapOkButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 제목 변경
        titleTextField.rx.text.orEmpty
            .filter { !$0.isEmpty }
            .map { Reactor.Action.didChangeTitle($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // textView 사용자가 입력 시작
        textView.rx.didBeginEditing
            .map { Reactor.Action.didBeginEditing }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        //textView text 감지
        textView.rx.text.orEmpty
            .distinctUntilChanged()
            .skip(1)
            .map { Reactor.Action.didChangeTextViewEditing($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // textView 사용자가 입력 종료 (textView가 비활성화)
        textView.rx.didEndEditing
            .map { Reactor.Action.didEndTextViewEditing }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        
        // State
        
        // 댓글 내용에 따른 색상 변화
        reactor.state
            .map { $0.content }
            .bind(with: self, onNext: { owner, content in
                owner.textView.textColor =
                content == "내용을 입력해주세요" ? .customColor(.gray3) : .black
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.category }
            .bind(to: titleNaviLabel.rx.text)
            .disposed(by: disposeBag)
        
    }
}
