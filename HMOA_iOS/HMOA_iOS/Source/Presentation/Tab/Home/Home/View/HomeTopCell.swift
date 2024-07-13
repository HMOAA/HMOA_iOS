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
    
    private lazy var newsImageView = UIImageView().then {
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 12
    }
    
    private lazy var hbtiButton = UIButton().then {
        $0.setTitle("# 향bti 검사하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .customFont(.pretendard, 14)
        $0.backgroundColor = #colorLiteral(red: 0.09803920239, green: 0.09803920239, blue: 0.09803920239, alpha: 1)
        $0.layer.cornerRadius = 8
    }
    
    private lazy var banerView = UIView().then {
        $0.backgroundColor =  #colorLiteral(red: 0.9607843137, green: 0.9450980392, blue: 0.9529411765, alpha: 1)
    }
    private lazy var banerLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_medium, size: 14, color: .banerLabelColor)
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
        
        newsImageView.addSubview(hbtiButton)
        
        [newsImageView, banerView] .forEach { addSubview($0) }
        
        newsImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        hbtiButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.bottom.equalToSuperview().inset(26)
            make.height.equalTo(47)
        }
        
        banerView.snp.makeConstraints { make in
            make.top.equalTo(newsImageView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(36)
        }
        
        banerLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
    }
    
    func setImage(_ item: HomeFirstData) {
        let url = URL(string: item.mainImage)
        banerLabel.text =  item.banner
        newsImageView.kf.setImage(with: url)
    }
}
