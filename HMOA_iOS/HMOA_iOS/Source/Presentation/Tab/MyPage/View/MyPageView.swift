//
//  MyPageView.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/01/21.
//

import UIKit
import SnapKit

class MyPageView: UIView {
    
    // MARK: Properies
    let myPageTopView = MyPageTopView()
    
    let scrollView = UIScrollView()
    
    lazy var tableView = UITableView().then {
        $0.register(MyPageCell.self, forCellReuseIdentifier: MyPageCell.identifier)
        $0.isScrollEnabled = false
    }
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Functions

extension MyPageView {
    
    func configureUI() {
        
        [scrollView] .forEach { addSubview($0) }
        
        [myPageTopView, tableView] .forEach { scrollView.addSubview($0) }
        
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        myPageTopView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(205)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(myPageTopView.snp.bottom)
            $0.leading.trailing.bottom.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView)
            $0.height.equalTo(500)
        }
    }
}
