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
    
    lazy var brandButton = UIButton().then {
        $0.makeCategoryButton("브랜드")
    }
    
    lazy var postButton = UIButton().then {
        $0.makeCategoryButton("포스트")
    }
    
    lazy var hpediaButton = UIButton().then {
        $0.makeCategoryButton("Hpedia")
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
        [   productButton,
            brandButton,
            postButton,
            hpediaButton
        ]   .forEach { addSubview($0) }
        
        productButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(14)
            $0.leading.equalToSuperview().inset(16)
            $0.height.equalTo(22)
        }
        
        brandButton.snp.makeConstraints {
            $0.top.equalTo(productButton)
            $0.leading.equalTo(productButton.snp.trailing).offset(8)
            $0.height.equalTo(22)
        }
        
        postButton.snp.makeConstraints {
            $0.top.equalTo(productButton)
            $0.leading.equalTo(brandButton.snp.trailing).offset(8)
            $0.height.equalTo(22)
        }
        
        hpediaButton.snp.makeConstraints {
            $0.top.equalTo(productButton)
            $0.leading.equalTo(postButton.snp.trailing).offset(8)
            $0.height.equalTo(22)
        }
    }
}
