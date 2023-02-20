//
//  HomeWatchCell.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/01/19.
//

import UIKit
import SnapKit
import Then

class HomeWatchCell: UICollectionViewCell {
    
    // MARK: - identifier
    
    static let identifier = "HomeWatchCell"
    
    // MARK: - Properties
    
    lazy var perfumeImageView = UIImageView().then {
        $0.layer.borderWidth = 0.5
        $0.contentMode = .scaleAspectFit
    }

    
    let perfumeNameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 8, weight: .bold)
    }
    
    let perfumeInfoLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 8)
        $0.numberOfLines = 2
        $0.textAlignment = .right
    }
    
    // MARK: - Lifecycle

    override func layoutSubviews() {
        configureUI()
    }
}

// MARK: - Functions

extension HomeWatchCell {
    
    func configureUI() {
        [perfumeImageView, perfumeNameLabel, perfumeInfoLabel] .forEach { addSubview($0) }
        
        perfumeImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        perfumeInfoLabel.snp.makeConstraints {
            $0.bottom.equalTo(perfumeImageView)
            $0.trailing.equalTo(perfumeImageView)
            $0.width.equalTo(75)
        }
        
        perfumeNameLabel.snp.makeConstraints {
            $0.bottom.equalTo(perfumeInfoLabel.snp.top)
            $0.trailing.equalTo(perfumeInfoLabel)
        }
    }
    
    func setUI(item: Perfume) {
        perfumeInfoLabel.text = item.content
        perfumeNameLabel.text = item.titleName
        perfumeImageView.image = item.image
    }
}
