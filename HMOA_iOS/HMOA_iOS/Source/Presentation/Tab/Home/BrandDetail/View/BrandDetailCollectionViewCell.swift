//
//  BrandDetailCollectionViewCell.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/03/18.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import ReactorKit

class BrandDetailCollectionViewCell: UICollectionViewCell {

    var disposeBag = DisposeBag()
    
    
    static let identifier = "BrandDetailCollectionViewCell"

    // MARK: - UI Component
    
    lazy var productImageView = UIImageView()
    
    var titleLabel = UILabel().then {
        $0.font = .customFont(.pretendard_medium, 14)
    }
    
    var contentLabel = UILabel().then {
        $0.numberOfLines = 2
        $0.font = .customFont(.pretendard, 12)
    }
    
    lazy var likeButton = UIButton().then {
        $0.setImage(UIImage(named: "heart"), for: .normal)
        $0.setImage(UIImage(named: "heart_fill"), for: .selected)
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

extension BrandDetailCollectionViewCell {

    
    // MARK: - Configure
    func configureUI() {
        [   productImageView,
            titleLabel,
            contentLabel,
            likeButton
        ]   .forEach { addSubview($0) }
        
        
        productImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(productImageView.snp.width)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(productImageView.snp.bottom).offset(12)
            $0.leading.equalToSuperview()
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(6)
            $0.leading.trailing.equalToSuperview()
        }
        
        likeButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel)
            $0.trailing.equalToSuperview()
        }
    }
    
    
    func bindUI(_ data: BrandPerfume) {
        titleLabel.text = data.brandName
        contentLabel.text = data.perfumeName
        likeButton.isSelected = data.liked
        productImageView.kf.setImage(with: URL(string: data.perfumeImgUrl))
    }
}



