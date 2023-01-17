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
    
    lazy var newsImageView = UIImageView().then {
        $0.image = UIImage(named: "newsImage")
    }
    
    lazy var leftButton: UIButton = {
        
        let button = UIButton()
        
        button.setImage(UIImage(named: "leftButton"), for: .normal)
        
        return button
        
    }()
    
    lazy var rightButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(named: "rightButton"), for: .normal)
        
        return button
    }()
    
    // MARK: - Lifecycle
    override func layoutSubviews() {
        configureUI()
    }
}

// MARK: Functions

extension HomeTopCell {
    
    func configureUI() {
        [newsImageView, leftButton, rightButton] .forEach { addSubview($0) }
        
        newsImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
//            $0.width.equalTo(335)
//            $0.height.equalTo(202)
        }
        
        leftButton.snp.makeConstraints {
            $0.centerY.equalTo(newsImageView)
            $0.leading.equalTo(newsImageView.snp.leading).inset(14)
        }
        
        rightButton.snp.makeConstraints {
            $0.centerY.equalTo(leftButton)
            $0.trailing.equalTo(newsImageView.snp.trailing).inset(14)
        }
    }
}
