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
        
        [myPageTopView] .forEach { addSubview($0) }
        
        myPageTopView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
