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

class HomeCell: UICollectionViewCell, View {
    
    typealias Reactor = HomeCellReactor
    
    // MARK: - identifier
    var disposeBag = DisposeBag()
    static let identifier = "HomeCell"
    
    // MARK: - Properties
    let perfumeImageView = UIImageView().then {
        $0.backgroundColor = #colorLiteral(red: 0.8784313725, green: 0.8735057712, blue: 0.87650913, alpha: 0.3)
        $0.layer.cornerRadius = 3
        $0.contentMode = .scaleAspectFit
    }
    
    let perfumeTitleLabel = UILabel().then {
        $0.font = .customFont(.pretendard_medium, 12)
    }
    
    let perfumeInfoLabel = UILabel().then {
        $0.font = .customFont(.pretendard, 12)
        $0.numberOfLines = 2
    }
    
    override func layoutSubviews() {
        configureUI()
    }
}

extension HomeCell {
    
    func bind(reactor: HomeCellReactor) {
        
        // 향수 브랜드 label 바인딩
        reactor.state
            .map { $0.title }
            .bind(to: perfumeTitleLabel.rx.text)
            .disposed(by: disposeBag)
        
        // 향수 제품명 label 바인딩
        reactor.state
            .map { $0.content }
            .bind(to: perfumeInfoLabel.rx.text)
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
