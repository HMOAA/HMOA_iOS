//
//  HomeWatchCell.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/01/19.
//

import UIKit
import SnapKit
import Then
import ReactorKit
import RxCocoa
import RxSwift


class HomeFirstCell: UICollectionViewCell{

    // MARK: - identifier
    
    static let identifier = "HomeFirstCell"
    
    // MARK: - Properties

    private lazy var perfumeImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }

    
    private let perfumeBrandLabel = UILabel().then {
        $0.font = .customFont(.pretendard_medium, 12)
    }
    
    private let perfumeInfoLabel = UILabel().then {
        $0.font = .customFont(.pretendard, 12)
        $0.numberOfLines = 3
        $0.textAlignment = .left
    }
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Functions

extension HomeFirstCell {
    
    private func configureUI() {
        [
            perfumeBrandLabel,
            perfumeInfoLabel,
            perfumeImageView
        ] .forEach { addSubview($0) }
        layer.cornerRadius = 3
        backgroundColor = #colorLiteral(red: 0.8784313725, green: 0.8735057712, blue: 0.87650913, alpha: 1)
        
        
        perfumeBrandLabel.snp.makeConstraints {
            $0.bottom.leading.equalToSuperview().inset(8)
        }
        
        perfumeImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func bindUI(_ data: RecommendPerfume, _ row: Int) {
        perfumeBrandLabel.text = data.brandName
        perfumeImageView.kf.setImage(with: URL(string: data.imgUrl))
        
        switch row {
        case 0:
            perfumeImageView.snp.remakeConstraints {
                $0.top.equalToSuperview().inset(37)
                $0.bottom.equalToSuperview().inset(42)
                $0.leading.trailing.equalToSuperview().inset(18)
            }
        case 1:
            perfumeImageView.snp.remakeConstraints  {
                $0.top.equalToSuperview().inset(30)
                $0.bottom.equalToSuperview().inset(38)
                $0.leading.trailing.equalToSuperview().inset(18)
            }
        case 2:
            perfumeImageView.snp.remakeConstraints  {
                $0.top.equalToSuperview().inset(20)
                $0.bottom.equalToSuperview().inset(28)
                $0.leading.trailing.equalToSuperview().inset(8)
            }
        case 3:
            perfumeImageView.snp.remakeConstraints  {
                $0.top.equalToSuperview().inset(17)
                $0.bottom.equalToSuperview().inset(26)
                $0.leading.trailing.equalToSuperview().inset(23)
            }
        default:
            perfumeImageView.snp.remakeConstraints  {
                $0.top.equalToSuperview().inset(22)
                $0.bottom.equalToSuperview().inset(28)
                $0.leading.trailing.equalToSuperview().inset(25)
            }
        }
    }
}
