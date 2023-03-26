//
//  MyPageSeparatorLineView.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/03/24.
//

import Foundation
import UIKit

class MyPageSeparatorLineView: UITableViewHeaderFooterView {
        
    // MARK: - identifier
    static let ientfifier = "MyPageSeparatorLineView"
    
    // MARK: - UI Component
    
    var lineView = UIView().then {
        $0.backgroundColor = .customColor(.gray2)
    }
    
    // MARK: - init
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MyPageSeparatorLineView {
    
    // MARK: - Configure
    func configureUI() {
        
        addSubview(lineView)
        
        lineView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(2)
        }
    }
}

