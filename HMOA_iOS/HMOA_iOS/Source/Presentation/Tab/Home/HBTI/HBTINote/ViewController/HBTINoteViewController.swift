//
//  HBTINoteViewController.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 8/15/24.
//

import UIKit

import SnapKit
import ReactorKit
import RxCocoa
import RxSwift
import SnapKit
import Then

class HBTINoteViewController: UIViewController, View {
    
    // MARK: - Properties
    
    var disposeBag = DisposeBag()
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: setUI 함수로 옮기기
        view.backgroundColor = .white
    }
    
    func bind(reactor: HBTINoteReactor) {
        
        // MARK: Action
        
        
        // MARK: State
        
    }

}
