//
//  ProductPriceView.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 9/27/24.
//

import UIKit

import SnapKit
import Then

final class ProductPriceView: UIView {

    // MARK: - UI Components
    
    private let titleLabel = UILabel()

    private let priceLabel = UILabel()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAddView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Function
    
    private func setAddView() {
        [
            titleLabel,
            priceLabel
        ].forEach { addSubview($0) }
    }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.verticalEdges.leading.equalToSuperview()
        }
        
        priceLabel.snp.makeConstraints { make in
            make.verticalEdges.trailing.equalToSuperview()
        }
    }
    
    func configureView(title: String, price: Int, color: Colors) {
        titleLabel.setLabelUI(title, font: .pretendard, size: 12, color: color)
        priceLabel.setLabelUI(price.numberFormatterToHangulWon(), 
                              font: .pretendard,
                              size: 12,
                              color: color)
    }
}
