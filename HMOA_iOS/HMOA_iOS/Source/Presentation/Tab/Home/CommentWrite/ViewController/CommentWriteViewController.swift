//
//  CommentWriteViewController.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/02/22.
//

import UIKit
import SnapKit
import Then
import ReactorKit
import RxSwift
import RxCocoa

class CommentWriteViewController: UIViewController, View {
    typealias Reactor = CommentWriteReactor
    
    // MARK: - Properties
    
    var disposeBag = DisposeBag()
    
    // MARK: - UI Component
    private let titleLabel = UILabel().then {
        $0.text = "댓글"
        $0.font = .customFont(.pretendard_medium, 20)
        $0.textColor = .black
    }
    
    private let cancleButton = UIButton().then {
        $0.setTitle("취소", for: .normal)
        $0.titleLabel?.font = .customFont(.pretendard, 16)
        $0.setTitleColor(.black, for: .normal)
        $0.tintColor = .black
    }
    
    private let okButton = UIButton().then {
        $0.setTitle("확인", for: .normal)
        $0.titleLabel?.font = .customFont(.pretendard, 16)
        $0.setTitleColor(.black, for: .normal)
        $0.tintColor = .black
    }
    
    private lazy var textView = UITextView().then {
        $0.font = .customFont(.pretendard, 14)
        $0.textAlignment = .left
    }

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setOkCancleNavigationBar(okButton: okButton, cancleButton: cancleButton, titleLabel: titleLabel)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        textView.resignFirstResponder()
        
    }
}

// MARK: - Functions
extension CommentWriteViewController {
    
    // MARK: - Bind
    func bind(reactor: CommentWriteReactor) {
        
        // MARK: - Action
        
        // 취소 버튼 클릭
        cancleButton.rx.tap
            .map { Reactor.Action.didTapCancleButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 확인 버튼 클릭
        okButton.rx.tap
            .map { Reactor.Action.didTapOkButton }
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
        
        // MARK: - State
        
        // 사용자가 입력 종료 (textView 비활성화)
        reactor.state
            .map { $0.isEndEditing }
            .distinctUntilChanged()
            .filter { $0 }
            .asDriver(onErrorRecover: { _ in return .empty() })
            .drive(with: self, onNext: { owner, _ in
                if owner.textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    owner.textView.text = "해당 제품에 대한 의견을 남겨주세요"
                    owner.textView.textColor = .customColor(.gray3)
                }
            })
            .disposed(by: disposeBag)
        
        // 댓글 내용에 따른 색상 변화
        reactor.state
            .map { $0.content }
            .asDriver(onErrorRecover: { _ in return .empty() })
            .drive(with: self, onNext: { owner, content in
                owner.textView.textColor =
                content == "해당 제품에 대한 의견을 남겨주세요" ? .customColor(.gray3) : .black
                
                owner.textView.text = content
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.content }
            .observe(on: MainScheduler.instance)
            .bind(to: textView.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func configureUI() {
        
        view.backgroundColor = .white
        view.addSubview(textView)
        
        textView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.leading.trailing.equalToSuperview().inset(32)
            $0.height.equalTo(588)
        }
    }
    
    
}
