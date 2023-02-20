//
//  HomeCell.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/01/16.
//

import UIKit
import SnapKit
import Then

class HomeCell: UICollectionViewCell {
    
    // MARK: - identifier
    static let identifier = "HomeCell"
    
    // MARK: - Properties
    let perfumeImageView = UIImageView().then {
        $0.layer.borderWidth = 0.5
    }
    
    let perfumeTitleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 12, weight: .bold)
    }
    
    let perfumeInfoLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 10)
        $0.numberOfLines = 2
    }
    
    override func layoutSubviews() {
        configureUI()
    }
}

extension HomeCell {
    
    func configureUI() {
        [perfumeImageView, perfumeTitleLabel, perfumeInfoLabel] .forEach { addSubview($0) }
        
        perfumeImageView.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.width.height.equalTo(93)
        }
        
        perfumeTitleLabel.snp.makeConstraints {
            $0.top.equalTo(perfumeImageView.snp.bottom).offset(8)
            $0.leading.equalToSuperview()
            $0.height.equalTo(12)
        }
        
        perfumeInfoLabel.snp.makeConstraints {
            $0.top.equalTo(perfumeTitleLabel.snp.bottom).offset(5)
            $0.leading.equalToSuperview()
            $0.width.equalTo(perfumeImageView.snp.width)
        }
    }
    
    func setUI(item: Perfume) {
        perfumeInfoLabel.text = item.content
        perfumeTitleLabel.text = item.titleName
        perfumeImageView.image = item.image
    }
}
