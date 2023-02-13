//
//  NewsCell.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/01/27.
//

import UIKit
import SnapKit
import Then

class NewsCell: UICollectionViewCell {
    
    // MARK: - identifier
    
    static let identifier = "NewsCell"
    
    lazy var titleImageView = UIImageView().then {
        $0.image = UIImage(named: "channel")
    }
    
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        configureUI()
    }
}

// MARK: - Functions

extension NewsCell {
    
    func configureUI() {
        
        [ titleImageView ] .forEach { addSubview($0) }
        
        titleImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
