//
//  HomeTopCell.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/01/16.
//

import UIKit
import SnapKit
import Then
import Kingfisher

class HomeTopCell: UICollectionViewCell {
    
    // MARK: - identifier
    static let identifier = "HomeTopCell"
    
    // MARK: - Properies
    
    private lazy var newsImageView = UIImageView()
    
    private lazy var banerView = UIView().then {
        $0.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9450980392, blue: 0.9529411765, alpha: 1)
    }
    private lazy var banerLabel = UILabel().then {
        $0.setLabelUI("앱 출시 기념 시향카드 증정 이벤트 예정 2/1~", font: .pretendard_medium, size: 14, color: .banerLabelColor)
    }
    
    // MARK: - Lifecycle
    override func layoutSubviews() {
        configureUI()
    }
}

// MARK: Functions

extension HomeTopCell {
    
    func configureUI() {
        banerView.addSubview(banerLabel)
        
        [newsImageView, banerView] .forEach { addSubview($0) }
        
        newsImageView.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
        }
        
        banerView.snp.makeConstraints { make in
            make.top.equalTo(newsImageView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(36)
        }
        
        banerLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
    }
    
    func setImage(_ imageUrl: String) {
        let url = URL(string: imageUrl)
        
        newsImageView.kf.setImage(with: url)
    }
}
