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
        $0.image = UIImage(named: "jomalon")
        $0.layer.borderWidth = 0.5
        $0.contentMode = .scaleAspectFit
    }

    
    let perfumeNameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 8, weight: .bold)
        $0.text = "조 말론 런던"
    }
    
    let perfumeInfoLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 8)
        $0.text = "우드 세이지 앤 씨 솔트 코튼 100ml"
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
}
