//
//  OrderCancelDetailViewController.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 9/26/24.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift
import SnapKit
import Then

final class OrderCancelDetailViewController: UIViewController, View {

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
    
    func bind(reactor: OrderCancelDetailReactor) {
        
        // MARK: Action
        
        // MARK: State
    }
    
    // MARK: - Functions
    
    private func setUI() {
        setClearBackNaviBar("", .black)
        view.backgroundColor = .white
    }
    
    // MARK: Add Views
    private func setAddView() {
        [
            
        ]   .forEach { view.addSubview($0) }
    }
    
    // MARK: Set Constraints
    private func setConstraints() {
        
    }
}
