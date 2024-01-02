//
//  BrandListCollectionViewCell.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/03/17.
//

import UIKit

import Then

class BrandListCollectionViewCell: UICollectionViewCell {
    
    // MARK: - identifier
    static let identifier = "BrandListCollectionViewCell"
    
    // MARK: - UI Component
    private lazy var brandImageBorderView = UIView().then {
        $0.layer.cornerRadius = 3
        $0.layer.borderWidth = 2
        $0.layer.borderColor = UIColor.customColor(.gray2).cgColor
    }
    private lazy var brandImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var brandLabel = UILabel().then {
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
        brandImageBorderView.addSubview(brandImageView)
        [
            brandImageBorderView,
            brandLabel
        ]   .forEach { addSubview($0) }
        
        brandImageBorderView.snp.makeConstraints {
            $0.leading.top.equalToSuperview()
            $0.width.equalTo((UIScreen.main.bounds.width - 56) / 4)
            $0.height.equalTo(brandImageBorderView.snp.width)
        }
        
        brandImageView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(8)
            $0.top.bottom.equalToSuperview()
        }
        
        brandLabel.snp.makeConstraints {
            $0.top.equalTo(brandImageBorderView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    func updateCell(_ item: Brand)  {
        brandLabel.text = item.brandName
        brandImageView.kf.setImage(with: URL(string: item.brandImageUrl))
    }
}
