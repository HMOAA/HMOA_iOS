//
//  HBTISurveyViewController.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 7/12/24.
//

import UIKit

import SnapKit
import ReactorKit
import RxCocoa
import RxSwift
import SnapKit
import Then

class HBTISurveyViewController: UIViewController, View {
    
    // MARK: - UI Components
    
    // MARK: - Properties
    
    var disposeBag = DisposeBag()
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }
    
    // MARK: - Bind
    
    func bind(reactor: HBTISurveyReactor) {
        
        // MARK: Action
        
        
        // MARK: State
        
    }
    
    // MARK: - Functions
    
    // MARK: Set UI
    func setUI() {
        setBackItemNaviBar("향BTI")
    }
}
