//
//  NotificationViewController.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 6/17/24.
//

import UIKit
import SnapKit
import ReactorKit
import RxCocoa
import RxSwift

class PushAlarmViewController: UIViewController, View {
    
    // MARK: - Properties
    
    var disposeBag = DisposeBag()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    // MARK: - Bind
    
    func bind(reactor: PushAlarmReactor) {
        
    }
    
    func setUI() {
        view.backgroundColor = .white
        setBackBellNaviBar("H M O A")
    }
}
