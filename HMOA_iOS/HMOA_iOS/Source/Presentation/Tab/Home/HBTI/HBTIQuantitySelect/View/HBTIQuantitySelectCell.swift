//
//  HBTIQuantitySelectBottomView.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 8/17/24.
//

import UIKit
import SnapKit
import Then

final class HBTIQuantitySelectCell: UITableViewCell, ReuseIdentifying {
    
    // MARK: - UI Components
    private let quantityButton = HBTIQuantitySelectButton()
    
    // MARK: - LifeCycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setAddView()
        setConstraints()
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Set UI
    
    private func setUI() {
        
    }
    
    // MARK: Add Views
    
    private func setAddView() {
        contentView.addSubview(quantityButton)
    }
    
    // MARK: Set Constraints
    
    private func setConstraints() {
        quantityButton.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0))
            $0.height.equalTo(50)
        }
    }
    
    func configureCell(quantity: String) {
        quantityButton.quantityLabel.text = quantity
    }
}
