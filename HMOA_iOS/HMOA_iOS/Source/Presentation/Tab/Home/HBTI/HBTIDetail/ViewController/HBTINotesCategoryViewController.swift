//
//  HBTINotesCategoryViewController.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 7/30/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import ReactorKit

class HBTINotesCategoryViewController: UIViewController, View {
    private let hbtiNotesCategoryView = HBTINotesCategoryView()
    typealias Reactor = HBTINotesCategoryReactor
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
        view.addSubview(hbtiNotesCategoryView)
    }
    
    private func setConstraints() {
        hbtiNotesCategoryView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func bind(reactor: HBTINotesCategoryReactor) {
        // 다음 버튼 터치 이벤트
        hbtiNotesCategoryView.nextButton.rx.tap
            .map { HBTINotesCategoryReactor.Action.didTapNextButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isPushNextVC }
            .distinctUntilChanged()
            .filter { $0 }
            .asDriver(onErrorRecover: { _ in .empty() })
            .drive(with: self, onNext: { owner, _ in
                let notesResultVC = HBTINotesResultViewController(reactor: HBTINotesResultReactor(selectedNotes: []))
                owner.navigationController?.pushViewController(notesResultVC, animated: true)
            })
            .disposed(by: disposeBag)
            
    }
}
