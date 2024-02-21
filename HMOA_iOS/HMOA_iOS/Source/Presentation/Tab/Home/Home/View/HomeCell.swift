//
//  HomeCell.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/01/16.
//

import UIKit
import SnapKit
import Then
import ReactorKit
import RxCocoa
import RxSwift

class HomeCell: UICollectionViewCell {
    
    // MARK: - identifier
    static let identifier = "HomeCell"
    
    // MARK: - Properties
    private let perfumeImageView = UIImageView().then {
        $0.backgroundColor = #colorLiteral(red: 0.8784313725, green: 0.8735057712, blue: 0.87650913, alpha: 0.3)
        $0.layer.cornerRadius = 3
        $0.contentMode = .scaleAspectFit
    }
    
    private let perfumeTitleLabel = UILabel().then {
        $0.font = .customFont(.pretendard_medium, 12)
    }
    
    private let perfumeInfoLabel = UILabel().then {
        $0.font = .customFont(.pretendard, 12)
        $0.numberOfLines = 2
    }
    
    override func layoutSubviews() {
        configureUI()
    }
}

extension HomeCell {
    
    private func configureUI() {
        [perfumeImageView, perfumeTitleLabel, perfumeInfoLabel] .forEach { addSubview($0) }
        
        perfumeImageView.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.width.height.equalTo(126)
        }
        
        perfumeTitleLabel.snp.makeConstraints {
            $0.top.equalTo(perfumeImageView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
        }
        
        perfumeInfoLabel.snp.makeConstraints {
            $0.top.equalTo(perfumeTitleLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    func bindUI(_ data: RecommendPerfume) {
        perfumeInfoLabel.text = data.perfumeName
        perfumeTitleLabel.text = data.brandName
        perfumeImageView.kf.setImage(with: URL(string: data.imgUrl))
    }
}
