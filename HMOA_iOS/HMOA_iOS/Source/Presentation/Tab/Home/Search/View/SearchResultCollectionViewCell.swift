//
//  SearchResultCollectionViewCell.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/03/02.
//

import UIKit

import Then
import Kingfisher

class SearchResultCollectionViewCell: UICollectionViewCell {
    
    // MARK: - identifier
    
    static let identifier = "SearchResultCollectionViewCell"
    
    // MARK: - UI Component
    
    lazy var productImageView = UIImageView().then {
        $0.backgroundColor = #colorLiteral(red: 0.8784313725, green: 0.8735057712, blue: 0.87650913, alpha: 0.3)
        $0.layer.cornerRadius = 3
        $0.layer.borderColor = UIColor.customColor(.gray2).cgColor
    }
    
    var brandLabel = UILabel().then {
        $0.font = .customFont(.pretendard_medium, 14)
    }
    
    var nameLabel = UILabel().then {
        $0.numberOfLines = 2
        $0.font = .customFont(.pretendard, 12)
    }
    
    lazy var likeButton = UIButton().then {
        $0.setImage(UIImage(named: "heart"), for: .normal)
        $0.setImage(UIImage(named: "heart_fill"), for: .selected)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SearchResultCollectionViewCell {
    
    func configureUI() {
        [   productImageView,
            brandLabel,
            nameLabel,
            likeButton
        ]   .forEach { addSubview($0) }
        
        
        productImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(productImageView.snp.width)
        }
        
        brandLabel.snp.makeConstraints {
            $0.top.equalTo(productImageView.snp.bottom).offset(12)
            $0.leading.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(brandLabel.snp.bottom).offset(6)
            $0.leading.trailing.equalToSuperview()
        }
        
        likeButton.snp.makeConstraints {
            $0.top.equalTo(brandLabel)
            $0.trailing.equalToSuperview()
        }
    }
    
    func updateCell(_ product: SearchPerfume) {
        self.productImageView.kf.setImage(with: URL(string: product.perfumeImageUrl))
        self.brandLabel.text = product.brandName
        self.nameLabel.text = product.perfumeName
    }
}
