//
//  HBTIViewController.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 7/11/24.
//

import UIKit

import SnapKit
import ReactorKit
import RxCocoa
import RxSwift
import SnapKit
import Then

final class HBTIViewController: UIViewController, View {
    
    // MARK: - UI Components
    
    private let scrollView = UIScrollView().then{
        $0.backgroundColor = .black
    }
    
    private let yourHBTIView = HBTIHomeTopView()
    
    private let introView = HBTIHomeBottomView()
    
    // MARK: - Properties
    
    var disposeBag = DisposeBag()
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAddView()
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setClearWhiteBackNaviBar("향BTI", .white)
    }
    
    // MARK: - Bind
    
    func bind(reactor: HBTIReactor) {
        
        // MARK: Action
        yourHBTIView.goToSurveyButton.rx.tap
            .map { Reactor.Action.didTapSurveyButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        yourHBTIView.selectNoteButton.rx.tap
            .map { Reactor.Action.didTapNoteButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: State
        reactor.state
            .map { $0.isTapSurveyButton }
            .filter { $0 }
            .map { _ in }
            .asDriver(onErrorRecover: { _ in return .empty() })
            .drive(onNext: presentHBTISurveyViewController)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isTapNoteButton }
            .filter { $0 }
            .map { _ in }
            .asDriver(onErrorRecover: { _ in return .empty() })
            .drive(onNext: presentHBTIPerfumeSurveyViewController)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Functions
    
    // MARK: Add Views
    private func setAddView() {
        view.addSubview(scrollView)
        
        [yourHBTIView, 
         introView
        ].forEach { scrollView.addSubview($0) }
        
    }
    
    // MARK: Set Constraints
    private func setConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        yourHBTIView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        introView.snp.makeConstraints { make in
            make.top.equalTo(yourHBTIView.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(20)
        }
    }
}
