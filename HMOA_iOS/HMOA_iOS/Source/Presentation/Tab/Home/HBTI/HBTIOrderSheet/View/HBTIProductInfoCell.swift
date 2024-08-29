//
//  HBTIProductInfoCell.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 8/29/24.
//

import UIKit
import SnapKit
import Then

final class HBTIProductInfoCell: UITableViewCell {
    
    // MARK: - UI Components
    
    private let productImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 30
        $0.layer.masksToBounds = true
    }
    
    private let productTitleLabel = UILabel().then {
        $0.setLabelUI("상품명", font: .pretendard_semibold, size: 14, color: .black)
    }
    
    private let productDescriptionLabel = UILabel().then {
        $0.setLabelUI("상품 상세 설명", font: .pretendard, size: 10, color: .black)
        $0.numberOfLines = 0
    }
   
    private let productCountLabel = UILabel().then {
        $0.setLabelUI("수량 0개", font: .pretendard, size: 10, color: .gray3)
    }
    
    private let removeProductButton = UIButton().then {
        $0.setImage(UIImage(named: "x"), for: .normal)
    }
   
    private let productPricePerUnitLabel = UILabel().then {
        $0.setLabelUI("0원/개", font: .pretendard, size: 10, color: .gray3)
    }
    
    private let productPriceLabel = UILabel().then {
        $0.setLabelUI("0원", font: .pretendard_semibold, size: 14, color: .black)
    }
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
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
         productPriceLabel
        ].forEach(addSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        productImageView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
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
            $0.top.equalTo(productDescriptionLabel.snp.bottom).offset(18)
            $0.leading.equalTo(productTitleLabel)
        }
        
        removeProductButton.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalTo(productTitleLabel)
        }
        
        productPricePerUnitLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.top.equalTo(removeProductButton.snp.bottom).offset(22)
        }
        
        productPriceLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.top.equalTo(productPricePerUnitLabel.snp.bottom).offset(2)
        }
    }
    
    func configureCell(with product: HBTIOrderSheetProductData) {
        productImageView.image = UIImage(named: product.image)
        productTitleLabel.text = product.title
        productDescriptionLabel.text = product.details
        productCountLabel.text = "수량 \(product.count)개"
        productPricePerUnitLabel.text = product.pricePerUnit
        productPriceLabel.text = "\(product.price)원"
    }
}
