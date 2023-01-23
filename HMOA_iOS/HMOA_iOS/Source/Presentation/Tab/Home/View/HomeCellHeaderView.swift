//
//  HomeCellHeaderView.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/01/16.
//

import UIKit
import SnapKit
import Then

class HomeCellHeaderView: UICollectionReusableView {
    
    // MARK: - identifier
    
    static let identifier = "HomeCellHeaderView"
    
    // MARK: - Properties
    let searchLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .bold)
        $0.text = "시트러스"
    }
    
    let forYouLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
        $0.text = "를 검색한 당신에게"
    }
    
    
    // MARK: - Lifecycle
    override func layoutSubviews() {
        configureUI()
    }
}

extension HomeCellHeaderView {
    func configureUI() {
        [searchLabel, forYouLabel] .forEach { addSubview($0) }
        
        searchLabel.snp.makeConstraints {
            $0.leading.top.equalToSuperview()
        }
        
        forYouLabel.snp.makeConstraints {
            $0.leading.equalTo(searchLabel.snp.trailing)
            $0.top.equalToSuperview()
        }
    }
}
