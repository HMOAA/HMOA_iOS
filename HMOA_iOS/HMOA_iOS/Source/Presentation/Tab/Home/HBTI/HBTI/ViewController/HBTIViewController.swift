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

class HBTIViewController: UIViewController, View {
    
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
        
        setUI()
        setAddView()
        setConstraints()
    }
    
    // MARK: - Bind
    
    func bind(reactor: HBTIReactor) {
        
        // MARK: Action
        
        
        // MARK: State
        
    }
    
    // MARK: - Functions
    
    private func setUI() {
        setClearBackNaviBar("향BTI", .white)
    }
    
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
