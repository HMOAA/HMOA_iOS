//
//  HBTIProcessGuideViewController.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 8/16/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import ReactorKit

final class HBTIProcessGuideViewController: UIViewController, View {
    
    // MARK: - Properties
    
    var disposeBag = DisposeBag()
    
    // MARK: - UI Components
    
    private let hbtiProcessGuideView = HBTIProcessGuideView()
    
    private let nextButton: UIButton = UIButton().makeValidHBTINextButton()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setAddView()
        setConstraints()
    }
    
    // MARK: - Bind
    
    func bind(reactor: HBTIProcessGuideReactor) {
        
        // MARK: Action
        
        nextButton.rx.tap
            .map { HBTIProcessGuideReactor.Action.didTapNextButton }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        // MARK: State
        
        reactor.state
            .map { $0.isPushNextVC }
            .distinctUntilChanged()
            .filter { $0 }
            .asDriver(onErrorRecover: { _ in .empty() })
            .drive(with: self, onNext: { owner, _ in
                owner.presentHBTIQuantitySelectViewController()
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Functions
    
    private func setUI() {
        view.backgroundColor = .white
        setBackItemNaviBar("향BTI")
    }
    
    // MARK: Add Views
    
    private func setAddView() {
        [
         hbtiProcessGuideView,
         nextButton
        ].forEach(view.addSubview)
    }
    
    // MARK: Set Constraints
    
    private func setConstraints() {
        hbtiProcessGuideView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(40)
            $0.height.equalTo(52)
        }
    }
}
