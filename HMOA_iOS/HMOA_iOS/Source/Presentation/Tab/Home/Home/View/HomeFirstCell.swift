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


class HomeFirstCell: UICollectionViewCell, View {
    
    typealias Reactor = HomeCellReactor

    // MARK: - identifier
    
    static let identifier = "HomeFirstCell"
    
    // MARK: - Properties
    var disposeBag = DisposeBag()

    lazy var perfumeImageView = UIImageView().then {
        $0.layer.cornerRadius = 3
        $0.contentMode = .scaleAspectFit
        $0.backgroundColor = #colorLiteral(red: 0.8784313725, green: 0.8735057712, blue: 0.87650913, alpha: 1)
    }

    
    let perfumeBrandLabel = UILabel().then {
        $0.font = .customFont(.pretendard_medium, 10)
    }
    
    let perfumeInfoLabel = UILabel().then {
        $0.font = .customFont(.pretendard, 10)
        $0.numberOfLines = 3
        $0.textAlignment = .left
    }
    
    // MARK: - Lifecycle

    override func layoutSubviews() {
        configureUI()
    }
}

// MARK: - Functions

extension HomeFirstCell {
    
    func bind(reactor: HomeCellReactor) {
        
        // 향수 브랜드 label 바인딩
        reactor.state
            .map { $0.title }
            .bind(to: perfumeBrandLabel.rx.text)
            .disposed(by: disposeBag)
        
        // 향수 imageView 바인딩
        reactor.state
            .map { $0.image }
            .map { URL(string: $0) }
            .bind(onNext: {
                self.perfumeImageView.kf.setImage(with: $0)
            })
            .disposed(by: disposeBag)
    }
    
    func configureUI() {
        [perfumeImageView, perfumeBrandLabel, perfumeInfoLabel] .forEach { addSubview($0) }
        
        perfumeImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        perfumeBrandLabel.snp.makeConstraints {
            $0.bottom.equalTo(perfumeImageView).inset(4)
            $0.leading.equalTo(perfumeImageView).inset(4)
        }
    }
    
    func bindUI(_ data: RecommendPerfume) {
        perfumeBrandLabel.text = data.brandName
        perfumeImageView.kf.setImage(with: URL(string: data.imgUrl))
    }
}
