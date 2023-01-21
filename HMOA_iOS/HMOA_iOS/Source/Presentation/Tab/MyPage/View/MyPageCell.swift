//
//  MyPageCell.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/01/21.
//

import UIKit
import SnapKit

class MyPageCell: UITableViewCell {
    
    // MARK: - identifier
    
    static let identifier = "MyPageCell"
    
    // MARK: - Properies
    
    let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .bold)
        $0.textAlignment = .left
    }
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        configureUI()
    }
}

// MARK: - Lifecycle

extension MyPageCell {
    
    func configureUI() {
        [titleLabel] .forEach { addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
        }
    }
    
    func updateCell(_ text: String) {
        titleLabel.text = text
    }
}
