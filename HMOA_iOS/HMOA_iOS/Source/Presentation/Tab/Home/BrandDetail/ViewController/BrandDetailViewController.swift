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
    
    let homeBarButton = UIButton().makeImageButton(UIImage(named: "homeNavi")!)
    let searchBarButton = UIButton().makeImageButton(UIImage(named: "search")!)
    let backBarButton = UIButton().makeImageButton(UIImage(named: "backButton")!)

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNavigationBar()
    }
}

extension BrandDetailViewController {
    
    // MARK: - Bind
    func bind(reactor: BrandDetailReactor) {
        
        
        // MARK: - State
        
        // NavigationBar title 설정
        reactor.state
            .map { $0.title }
            .distinctUntilChanged()
            .bind(onNext: self.setNavigationBarTitle)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Configure
    func configureUI() {
        
        view.backgroundColor = .white
    }
    
    func configureNavigationBar() {
        let backBarButtonItem = self.navigationItem.makeImageButtonItem(backBarButton)
        let homeBarButtonItem = self.navigationItem.makeImageButtonItem(homeBarButton)
        let searchBarButtonItem = self.navigationItem.makeImageButtonItem(searchBarButton)
        
        self.navigationItem.leftBarButtonItems = [backBarButtonItem, spacerItem(15), homeBarButtonItem]
        self.navigationItem.rightBarButtonItems = [searchBarButtonItem]
    }
}
