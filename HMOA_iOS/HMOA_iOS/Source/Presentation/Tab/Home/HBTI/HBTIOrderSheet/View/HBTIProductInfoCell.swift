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
        
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        
    }
}
