//
//  MyPageViewController.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/01/12.
//

import UIKit

class MyPageViewController: UIViewController {
    
    // MARK: - Properties
    let myPageView = MyPageView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setNavigationBarTitle(title: "마이페이지", isHidden: true)
    }
}

// MARK: - Functions

extension MyPageViewController {
    func configureUI() {
        [myPageView] .forEach { view.addSubview($0) }
        
        myPageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(205)
        }
    }
}
