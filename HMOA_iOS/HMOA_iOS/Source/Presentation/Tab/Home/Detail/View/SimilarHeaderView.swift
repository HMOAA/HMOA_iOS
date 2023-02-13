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
        $0.font = UIFont.customFont(.pretendard_medium, 16)
        $0.text = "이 제품도 좋아하실 것 같아요"
    }
    
    let seperatorLine = UIView().then {
        $0.backgroundColor = UIColor.customColor(.gray2)
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
        
        [   titleLabel,
            seperatorLine   ]   .forEach { addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        seperatorLine.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.width.equalTo(UIScreen.main.bounds.width - 32)
            $0.height.equalTo(1)
        }
    }
}
