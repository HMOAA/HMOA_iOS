//
//  BrandDetailViewController.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/03/18.
//

import UIKit
import SnapKit
import Then
import ReactorKit
import RxSwift
import RxCocoa

class BrandDetailViewController: UIViewController, View {
    typealias Reactor = BrandDetailReactor
    
    // MARK: - Properties
    var disposeBag = DisposeBag()
    

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
    }
}

extension BrandDetailViewController {
    
    func bind(reactor: BrandDetailReactor) {
        
    }
}
