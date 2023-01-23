//
//  HomeTopCellFooterView.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/01/17.
//

import UIKit
import SnapKit
import Then

class HomeTopCellFooterView: UICollectionReusableView {
    
    // MARK: - identifier
    static let identifier = "HomeTopCellFooterView"
    
    // MARK: - Properies
    
    let newsLetterLabel = UILabel().then {
        $0.text = "뉴스레터 모아보기"
        $0.font = .systemFont(ofSize: 14)
    }
    
    // MARK: - Lifecycle
    override func layoutSubviews() {
        configureUI()
    }
}

// MARK: - Functions
extension HomeTopCellFooterView {
    
    func configureUI() {
        addSubview(newsLetterLabel)
        
        newsLetterLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
