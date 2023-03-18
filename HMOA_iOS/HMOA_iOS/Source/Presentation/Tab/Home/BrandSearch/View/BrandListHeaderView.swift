//
//  BrandListHeaderView.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/03/17.
//

import UIKit

class BrandListHeaderView: UICollectionReusableView {
        
    // MARK: - identifier
    static let identifier = "BrandListHeaderView"
    
    // MARK: - UI Component
    var consonantLabel = UILabel().then {
        $0.clipsToBounds = true
        $0.textAlignment = .center
        $0.layer.cornerRadius = 10
        $0.backgroundColor = .black
        $0.textColor = .white
        $0.font = .customFont(.pretendard, 14)
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

extension BrandListHeaderView {
    
    // MARK: - configure
    func configureUI() {
        
        addSubview(consonantLabel)
        
        consonantLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(37)
            $0.height.equalTo(22)
        }
    }
    
    func updateUI(_ item: String) {
        consonantLabel.text = item
    }
}
