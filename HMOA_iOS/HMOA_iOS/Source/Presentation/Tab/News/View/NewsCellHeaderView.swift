//
//  NewsCellHeaderView.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/01/27.
//

import UIKit
import SnapKit
import Then

class NewsCellHeaderView: UICollectionReusableView {
    
    // MARK: - identifier
    
    static let identifier = "NewsCellHeaderView"
    
    // MARK: - Properties
    
    lazy var recentPostButton = UIButton().then {
        $0.setTitle("최근 포스트", for: .normal)
        $0.titleLabel!.font = .systemFont(ofSize: 14, weight: .medium)
        $0.setTitleColor(.black, for: .normal)
    }
    
    lazy var postButton = UIButton().then {
        $0.setTitle("포스트", for: .normal)
        $0.titleLabel!.font = .systemFont(ofSize: 14, weight: .medium)
        $0.setTitleColor(.black, for: .normal)
    }
    
    // MARK: - Lifecycle
    override func layoutSubviews() {
        configureUI()
    }
}

extension NewsCellHeaderView {
    
    func configureUI() {
        
        [recentPostButton, postButton] .forEach { addSubview($0) }
        
        recentPostButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
        }
        
        postButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(recentPostButton.snp.trailing).offset(10)
        }
    }
}
