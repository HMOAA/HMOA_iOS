//
//  OderLogViewController.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 9/23/24.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift
import SnapKit
import Then

final class OrderLogViewController: UIViewController, View {

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
    
    func bind(reactor: OrderLogReactor) {
        
        // MARK: Action
        
        // MARK: State
    }
    
    // MARK: - Functions
    
    private func setUI() {
        setClearBackNaviBar("주문 내역", .black)
        view.backgroundColor = .white
    }
    
    // MARK: Add Views
    private func setAddView() {
        
    }
    
    // MARK: Set Constraints
    private func setConstraints() {
        
    }

}
