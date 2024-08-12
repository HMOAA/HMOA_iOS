//
//  HBTINotesResultViewController.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 8/6/24.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa

class HBTINotesResultViewController: UIViewController, View {
    private let resultView = HBTINotesResultView()
    typealias Reactor = HBTINotesResultReactor
    var disposeBag = DisposeBag()
    
    // MARK: - Initialization
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
    }
    
    // MARK: - UI Setup
    private func setUI() {
        setClearBackNaviBar("향BTI", .black)
    }
    
    // MARK: - Binding
    func bind(reactor: HBTINotesResultReactor) {
        // Action
        resultView.nextButton.rx.tap
            .map { Reactor.Action.nextButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // State
        reactor.state.map { $0.selectedNotes }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] notes in
                self?.resultView.configureView(with: notes)
            })
            .disposed(by: disposeBag)
    }
}
