//
//  HBTIDetailViewController.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 7/29/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import ReactorKit

class HBTIProcessGuideViewController: UIViewController, View {
    var disposeBag = DisposeBag()
    private let hbtiProcessGuideView = HBTIProcessGuideView()
    
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
        view.addSubview(hbtiProcessGuideView)
    }
    
    private func setConstraints() {
        hbtiProcessGuideView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func bind(reactor: HBTIProcessGuideReactor) {
        // 다음 버튼 터치 이벤트
        hbtiProcessGuideView.nextButton.rx.tap
            .map { HBTIProcessGuideReactor.Action.didTapNextButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isPushNextVC }
            .distinctUntilChanged()
            .filter { $0 }
            .asDriver(onErrorRecover: { _ in .empty() })
            .drive(with: self, onNext: { owner, _ in
                let quantityVC = HBTIQuantitySelectionViewController(reactor: HBTIQuantitySelectionReactor())
                owner.navigationController?.pushViewController(quantityVC, animated: true)
            })
            .disposed(by: disposeBag)
            
    }
}
