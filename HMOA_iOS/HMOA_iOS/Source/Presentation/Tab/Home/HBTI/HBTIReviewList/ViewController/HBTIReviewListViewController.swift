//
//  HBTIReviewListViewController.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 10/22/24.
//

import UIKit

import SnapKit
import ReactorKit
import RxCocoa
import RxSwift
import SnapKit
import Then

final class HBTIReviewListViewController: UIViewController, View {
    
    // MARK: - UI Components
    
    
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
    
    func bind(reactor: HBTIReviewListReactor) {
        
        // MARK: Action
        
        
        // MARK: State
        
    }
    
    // MARK: - Functions
    
    // MARK: Set UI
    private func setUI() {
        view.backgroundColor = .black
        setClearWhiteBackNaviBar("향BTI 후기", .white)
    }
    
    // MARK: Add Views
    private func setAddView() {
        
        [
            
        ].forEach { view.addSubview($0) }
        
    }
    
    // MARK: Set Constraints
    private func setConstraints() {
        
    }
}
