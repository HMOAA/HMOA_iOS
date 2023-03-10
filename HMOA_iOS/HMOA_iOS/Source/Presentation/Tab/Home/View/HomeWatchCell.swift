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


class HomeWatchCell: UICollectionViewCell, View {
    
    typealias Reactor = HomeCellReactor

    // MARK: - identifier
    
    static let identifier = "HomeWatchCell"
    
    // MARK: - Properties
    var disposeBag = DisposeBag()

    lazy var perfumeImageView = UIImageView().then {
        $0.layer.borderWidth = 0.5
        $0.contentMode = .scaleAspectFit
    }

    
    let perfumeNameLabel = UILabel().then {
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

extension HomeWatchCell {
    
    func bind(reactor: HomeCellReactor) {
        perfumeInfoLabel.text = reactor.currentState.content
        perfumeNameLabel.text = reactor.currentState.title
        perfumeImageView.image = reactor.currentState.image
    }
    
    func configureUI() {
        [perfumeImageView, perfumeNameLabel, perfumeInfoLabel] .forEach { addSubview($0) }
        
        perfumeImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        perfumeInfoLabel.snp.makeConstraints {
            $0.bottom.equalTo(perfumeImageView).inset(4)
            $0.leading.equalTo(perfumeImageView).inset(4)
            $0.width.equalTo(75)
        }
        
        perfumeNameLabel.snp.makeConstraints {
            $0.bottom.equalTo(perfumeInfoLabel.snp.top)
            $0.leading.equalTo(perfumeInfoLabel)
        }
    }
    
    func setUI(item: Perfume) {
        perfumeInfoLabel.text = item.content
        perfumeNameLabel.text = item.titleName
        perfumeImageView.image = item.image
    }
}
