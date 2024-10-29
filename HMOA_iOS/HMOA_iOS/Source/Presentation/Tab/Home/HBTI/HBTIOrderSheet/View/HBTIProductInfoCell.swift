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
        $0.setLabelUI("디스크립션 라벨", font: .pretendard, size: 10, color: .black)
        $0.numberOfLines = 0
    }
   
    private let productCountLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard, size: 10, color: .gray3)
    }
    
    private let removeProductButton = UIButton().then {
        $0.setImage(UIImage(named: "xMark"), for: .normal)
    }
   
    private let productPricePerUnitLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard, size: 10, color: .gray3)
    }
    
    private let productPriceLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_semibold, size: 14, color: .black)
    }
    
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
    }
    
    func configureCell(product: HBTICategory) {
        productImageView.kf.setImage(with: URL(string: product.imageURL))
        productTitleLabel.text = product.name
////        var noteContent = ""
////        product.noteList.forEach { note in
////            noteContent += "\(note.content), "
//////            productDescriptionLabel.text = ""
//////            productDescriptionLabel.text! += note.content
////        }
////        productDescriptionLabel.text = noteContent
        productCountLabel.text = "수량 \(product.noteCount)개"
        productPricePerUnitLabel.text = "990원/개"
        productPriceLabel.text = "\(product.price.numberFormatterToHangulWon())"
    }
}
