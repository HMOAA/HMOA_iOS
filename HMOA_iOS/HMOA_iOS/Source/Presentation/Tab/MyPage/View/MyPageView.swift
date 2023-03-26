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
    
    lazy var tableView = UITableView(frame: .zero, style: .plain).then {
        $0.register(MyPageSeparatorLineView.self, forHeaderFooterViewReuseIdentifier: MyPageSeparatorLineView.ientfifier)
        $0.register(MyPageUserCell.self, forCellReuseIdentifier: MyPageUserCell.identifier)
        $0.register(MyPageCell.self, forCellReuseIdentifier: MyPageCell.identifier)
        $0.separatorStyle = .none
        $0.sectionHeaderTopPadding = 0
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
        
        addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
