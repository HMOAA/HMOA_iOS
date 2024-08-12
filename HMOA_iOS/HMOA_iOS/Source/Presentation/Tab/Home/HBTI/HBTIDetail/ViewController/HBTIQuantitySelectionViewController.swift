//
//  HBTIQuantitySelectionViewController.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 7/30/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import ReactorKit

class HBTIQuantitySelectionViewController: UIViewController, View {
    private let hbtiQuantityView = HBTIQuantitySelctionView()
    typealias Reactor = HBTIQuantitySelectionReactor
    var disposeBag = DisposeBag()
    
    init(reactor: Reactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setAddView()
        setConstraints()
    }
    
    private func setUI() {
        setClearBackNaviBar("향BTI", .black)
    }
    
    private func setAddView() {
        view.addSubview(hbtiQuantityView)
    }
    
    private func setConstraints() {
        hbtiQuantityView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func bind(reactor: HBTIQuantitySelectionReactor) {
        // 다음 버튼 터치 이벤트
        hbtiQuantityView.nextButton.rx.tap
            .map { HBTIQuantitySelectionReactor.Action.didTapNextButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isPushNextVC }
            .distinctUntilChanged()
            .filter { $0 }
            .asDriver(onErrorRecover: { _ in .empty() })
            .drive(with: self, onNext: { owner, _ in
                let categoryVC = HBTINotesCategoryViewController(reactor: HBTINotesCategoryReactor())
                owner.navigationController?.pushViewController(categoryVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
}
