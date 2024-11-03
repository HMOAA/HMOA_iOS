//
//  HBTINotesResultFooterView.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 8/24/24.
//

import UIKit
import SnapKit
import Then

class HBTINotesResultFooterView: UIView {
    
    // MARK: - UI Components
   
    private let totalPriceLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard, size: 15, color: .black)
        $0.textAlignment = .right
    }
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       
        setUI()
        setAddView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Set UI
    
    private func setUI() {

    }
    
    // MARK: Add Views
    
    private func setAddView() {
        addSubview(totalPriceLabel)
    }
    
    // MARK: Set Constraints
    
    private func setConstraints() {
        totalPriceLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: Other Functions
    
    func configurePriceLabel(price: Int) {
        totalPriceLabel.text = "총 금액 : \(price.numberFormatterToHangulWon())"
    }
}

