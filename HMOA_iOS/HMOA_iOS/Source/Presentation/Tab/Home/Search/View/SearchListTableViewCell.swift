//
//  SearchListTableViewCell.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/02/28.
//

import UIKit

class SearchListTableViewCell: UITableViewCell {

    // MARK: - identifier
    static let identifier = "SearchListTableViewCell"
    
    // MARK: - UI Component
    
    private var titleLabel = UILabel().then {
        $0.font = .customFont(.pretendard_light, 14)
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        configureUI()
    }
}

extension SearchListTableViewCell {
    
    // MARK: - Configure
    
    func configureUI() {
        
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
            $0.height.equalTo(34)
        }
    }
    
    func updateCell(_ title: String) {
        self.titleLabel.text = title
    }
}
