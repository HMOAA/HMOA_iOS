//
//  HBTISurveyResultViewController.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 8/12/24.
//

import UIKit

import SnapKit
import ReactorKit
import RxCocoa
import RxSwift
import SnapKit
import Then

class HBTISurveyResultViewController: UIViewController, View {
    
    // MARK: - UI Components
    
    private let loadingView = HBTILoadingView()
    
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
    
    func bind(reactor: HBTISurveyResultReactor) {
        
        // MARK: Action
        
        
        // MARK: State
        
    }
    
    // MARK: - Functions
    
    private func setUI() {
        setBackItemNaviBar("향BTI")
    }
    
    // MARK: Add Views
    private func setAddView() {
        view.addSubview(loadingView)
    }
    
    // MARK: Set Constraints
    private func setConstraints() {
        loadingView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
