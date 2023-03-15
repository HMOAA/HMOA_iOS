//
//  HomeTopCell.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/01/16.
//

import UIKit
import SnapKit
import Then

class HomeTopCell: UICollectionViewCell {
    
    // MARK: - identifier
    static let identifier = "HomeTopCell"
    
    // MARK: - Properies
    
    lazy var newsImageView = UIImageView()
    
    
    // MARK: - Lifecycle
    override func layoutSubviews() {
        configureUI()
    }
}

// MARK: Functions

extension HomeTopCell {
    
    func configureUI() {
        [newsImageView] .forEach { addSubview($0) }
        
        newsImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func setImage(_ image: UIImage) {
        newsImageView.image = image
    }
}
