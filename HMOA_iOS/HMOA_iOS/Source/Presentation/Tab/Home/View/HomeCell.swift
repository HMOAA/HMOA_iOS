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
        $0.layer.borderWidth = 0.5
    }
    
    let perfumeTitleLabel = UILabel().then {
        $0.font = .customFont(.pretendard_medium, 10)
    }
    
    let perfumeInfoLabel = UILabel().then {
        $0.font = .customFont(.pretendard, 10)
        $0.numberOfLines = 2
    }
    
    override func layoutSubviews() {
        configureUI()
    }
}

extension HomeCell {
    
    func bind(reactor: HomeCellReactor) {
        perfumeInfoLabel.text = reactor.currentState.content
        perfumeTitleLabel.text = reactor.currentState.title
        perfumeImageView.image = reactor.currentState.image
    }
    
    func configureUI() {
        [perfumeImageView, perfumeTitleLabel, perfumeInfoLabel] .forEach { addSubview($0) }
        
        perfumeImageView.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.width.height.equalTo(126)
        }
        
        perfumeTitleLabel.snp.makeConstraints {
            $0.bottom.equalTo(perfumeInfoLabel.snp.top).offset(-2)
            $0.leading.equalToSuperview().inset(4)
            $0.height.equalTo(10)
        }
        
        perfumeInfoLabel.snp.makeConstraints {
            $0.bottom.equalTo(perfumeImageView).inset(4)
            $0.leading.equalToSuperview().inset(4)
            $0.width.equalTo(perfumeImageView.snp.width)
        }
    }
    
    func setUI(item: Perfume) {
        perfumeInfoLabel.text = item.content
        perfumeTitleLabel.text = item.titleName
        perfumeImageView.image = item.image
    }
}
