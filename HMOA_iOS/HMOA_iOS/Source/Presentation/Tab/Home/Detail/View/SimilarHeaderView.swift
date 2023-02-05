//
//  SimilarHeaderView.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/02/05.
//

import UIKit
import SnapKit
import Then

class SimilarHeaderView: UICollectionReusableView {

    // MARK: - identifier
    
    static let identifier = "SimilarHeaderView"
    
    // MARK: - Properies
    
    let titleLabel = UILabel().then {
        $0.setLabelUI("비슷한 향수")
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
extension SimilarHeaderView {
    
    func configureUI() {
        
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
        }
    }
}
