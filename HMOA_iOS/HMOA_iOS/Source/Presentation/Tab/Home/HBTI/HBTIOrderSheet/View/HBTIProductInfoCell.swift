//
//  HBTIProductInfoCell.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 8/29/24.
//

import UIKit
import SnapKit
import Then

final class HBTIProductInfoCell: UICollectionViewCell, ReuseIdentifying {
    
    // MARK: - UI Components
    
    private let productImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 30
        $0.layer.masksToBounds = true
    }
    
    private let productTitleLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_semibold, size: 14, color: .black)
    }
    
    private let productDescriptionLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard, size: 10, color: .black)
        $0.numberOfLines = 0
    }
   
    private let productCountLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard, size: 10, color: .gray3)
    }
    
    let removeProductButton = UIButton().then {
        $0.setImage(UIImage(named: "xMark"), for: .normal)
    }
   
    private let productPricePerUnitLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard, size: 10, color: .gray3)
    }
    
    private let productPriceLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_semibold, size: 14, color: .black)
    }
    
    private let separatorView = HBTIOrderDividingLineView(color: .customColor(.gray1))
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAddView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set AddView
    
    private func setAddView() {
        [
         productImageView,
         productTitleLabel,
         productDescriptionLabel,
         productCountLabel,
         removeProductButton,
         productPricePerUnitLabel,
         productPriceLabel,
         separatorView
        ].forEach(addSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        productImageView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalToSuperview().offset(20)
            $0.width.height.equalTo(60)
        }
        
        productTitleLabel.snp.makeConstraints {
            $0.top.equalTo(productImageView.snp.top).offset(1)
            $0.leading.equalTo(productImageView.snp.trailing).offset(20)
        }
        
        productDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(productTitleLabel.snp.bottom).offset(4)
            $0.leading.equalTo(productTitleLabel)
        }
        
        productCountLabel.snp.makeConstraints {
            $0.bottom.equalTo(productImageView)
            $0.leading.equalTo(productTitleLabel)
        }
        
        removeProductButton.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalTo(productTitleLabel)
        }
        
        productPricePerUnitLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.bottom.equalTo(productPriceLabel.snp.top).offset(-2)
        }
        
        productPriceLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.bottom.equalTo(productImageView)
        }
        
        separatorView.snp.makeConstraints {
            $0.top.equalTo(productPriceLabel.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    
    func configureCell(product: HBTICategory, isSeparatorHidden: Bool) {
        productImageView.kf.setImage(with: URL(string: product.imageURL))
        productTitleLabel.text = product.name
        productDescriptionLabel.text = product.noteList.map { $0.name }.joined(separator: ", ")
        productCountLabel.text = "수량 \(product.noteCount)개"
        productPricePerUnitLabel.text = "990원/개"
        productPriceLabel.text = "\(product.price.numberFormatterToHangulWon())"
        separatorView.isHidden = isSeparatorHidden
    }
}
