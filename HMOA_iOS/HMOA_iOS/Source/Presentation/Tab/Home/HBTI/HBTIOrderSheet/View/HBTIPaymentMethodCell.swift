//
//  HBTIPaymentMethodCell.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 8/30/24.
//

import UIKit
import SnapKit
import Then

final class HBTIPaymentMethodCell: UITableViewCell, ReuseIdentifying {
    
    // MARK: - UI Components
    
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
    
    func configureCell() {
       
    }
}

