//
//  HomeWatchCellHeaderView.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/01/19.
//

import UIKit
import SnapKit
import Then

class HomeWatchCellHeaderView: UICollectionReusableView {
    
    // MARK: - identifier
    static let identifier = "HomeWatchCellHeaderView"
    
    // MARK: - Properties
    
    let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
        $0.text = "다른 사람들이 많이 본 향수"
    }
    
    lazy var moreButton = UIButton().then {
        $0.setTitle("랭킹더보기", for: .normal)
        $0.titleLabel!.font = .systemFont(ofSize: 10)
        $0.setTitleColor(.black, for: .normal)
    }
    
    // MARK: - Lifecycle
    override func layoutSubviews() {
        configureUI()
    }
}

// MARK: - Functions

extension HomeWatchCellHeaderView {
    func configureUI() {
        
        [titleLabel, moreButton] .forEach { addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.leading.equalToSuperview()
        }
        
        moreButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
        }
    }
}
