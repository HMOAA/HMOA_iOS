//
//  SearchResultTopView.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/03/02.
//

import UIKit

class SearchResultTopView: UIView {
    
    // MARK: - UI Component
    
    lazy var productButton = UIButton().then {
        $0.makeCategoryButton("상품")
    }
    
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configreUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SearchResultTopView {
    
    // MARK: - Configure
    
    func configreUI() {
        [   productButton
        ]   .forEach { addSubview($0) }
        
        productButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(14)
            $0.leading.equalToSuperview().inset(16)
            $0.height.equalTo(22)
        }
    }
}
