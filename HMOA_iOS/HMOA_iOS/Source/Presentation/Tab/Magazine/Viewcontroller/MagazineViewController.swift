//
//  MagazineViewController.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2/22/24.
//

import UIKit

import RxCocoa
import ReactorKit

class MagazineViewController: UIViewController, View {

    
    // MARK: - Properties
    
    var disposeBag = DisposeBag()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
    }
    
    
    // MARK: - Bind
    
    func bind(reactor: MagazineReactor) {
        
    }
}
