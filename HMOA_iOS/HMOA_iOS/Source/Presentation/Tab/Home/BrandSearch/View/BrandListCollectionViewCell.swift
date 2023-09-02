//
//  BrandListCollectionViewCell.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/03/17.
//

import UIKit

class BrandListCollectionViewCell: UICollectionViewCell {
    
    // MARK: - identifier
    static let identifier = "BrandListCollectionViewCell"
    
    // MARK: - UI Component
    lazy var brandImageView = UIImageView().then {
        $0.layer.borderWidth = 0.2
        $0.backgroundColor = .customColor(.gray3)
    }
    
    lazy var brandLabel = UILabel().then {
        $0.numberOfLines = 2
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

extension BrandListCollectionViewCell {
    
    // MARK: - Configure
    func configureUI() {
        
        [   brandImageView,
            brandLabel
        ]   .forEach { addSubview($0) }
        
        brandImageView.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.width.equalTo((UIScreen.main.bounds.width - 56) / 4)
            $0.height.equalTo(brandImageView.snp.width)
        }
        
        brandLabel.snp.makeConstraints {
            $0.top.equalTo(brandImageView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    func updateCell(_ item: Brand)  {
        brandLabel.text = item.brandName
        brandImageView.kf.setImage(with: URL(string: item.brandImageUrl))
    }
}
