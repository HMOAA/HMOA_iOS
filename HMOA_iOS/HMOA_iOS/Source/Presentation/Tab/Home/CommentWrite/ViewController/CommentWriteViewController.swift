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
    let titleLabel = UILabel().then {
        $0.text = "댓글"
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
    
    lazy var textField: UITextField = {
       let textField = UITextField()
        textField.font = .customFont(.pretendard, 14)
        textField.textAlignment = .left
        textField.contentVerticalAlignment = .top
        textField.attributedPlaceholder = NSAttributedString(string: "해당 제품에 대한 의견을 남겨주세요")
        return textField
    }()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNavigationBar()
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
        
        // MARK: - State
        
        // 화면 Pop
        reactor.state
            .map { $0.isPopVC }
            .distinctUntilChanged()
            .filter { $0 }
            .bind(onNext: self.popViewController)
            .disposed(by: disposeBag)
    }
    
    func configureUI() {
        
        view.backgroundColor = .white
        view.addSubview(textField)
        
        textField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.leading.trailing.equalToSuperview().inset(32)
            $0.height.equalTo(588)
        }
    }
    
    func configureNavigationBar() {
        let okButtonItem = UIBarButtonItem(customView: okButton)
        let cancleButtonItem = UIBarButtonItem(customView: cancleButton)
        
        self.navigationItem.titleView = titleLabel
        self.navigationItem.leftBarButtonItems = [cancleButtonItem]
        self.navigationItem.rightBarButtonItems = [okButtonItem]

    }
}
