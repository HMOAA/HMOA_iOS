//
//  PerfumeInfoCell.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/02/05.
//

import UIKit
import SnapKit
import Then
import ReactorKit
import RxCocoa
import RxSwift

class PerfumeInfoCell: UICollectionViewCell, View {
    
    typealias Reactor = PerfumeDetailReactor
    
    // MARK: - identifier
    
    static let identifier = "PerfumeInfoCell"
    var disposeBag = DisposeBag()

    // MARK: - View
    
    let perfumeInfoView = PerfumeInfoView()
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Functions

extension PerfumeInfoCell {
    
    func bind(reactor: PerfumeDetailReactor) {
        perfumeInfoView.perfumeImageView.image = reactor.currentState.perfumeImage
        perfumeInfoView.titleKoreanLabel.text = reactor.currentState.koreanName
        perfumeInfoView.titleEnglishLabel.text = reactor.currentState.englishName
        // 나중에 수정
//        perfumeInfoView.keywordTagListView.addTags(reactor.currentState.category)
        perfumeInfoView.priceLabel.text = "\(reactor.currentState.price)"
        perfumeInfoView.ageLabel.text = "\(reactor.currentState.age)"
        perfumeInfoView.gendarLabel.text = reactor.currentState.gender
        perfumeInfoView.productInfoContentLabel.text = reactor.currentState.productInfo
        perfumeInfoView.topNote.nameLabel.text = reactor.currentState.topTasting
        perfumeInfoView.heartNote.nameLabel.text = reactor.currentState.heartTasting
        perfumeInfoView.baseNote.nameLabel.text = reactor.currentState.baseTasting
        
        // action
        perfumeInfoView.perfumLikeView.likeButton.rx.tap
            .map { Reactor.Action.didTapPerfumeLikeButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        perfumeInfoView.brandView.likeButton.rx.tap
            .do(onNext: { print("Clicked")} )
            .map { Reactor.Action.didTapBrandLikeButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // state
        reactor.state
            .map { $0.isLikePerfume }
            .distinctUntilChanged()
            .bind(to:
                    perfumeInfoView.perfumLikeView.likeButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isLikeBrand }
            .distinctUntilChanged()
            .bind(to: perfumeInfoView.brandView.likeButton.rx.isSelected)
            .disposed(by: disposeBag)
    }
    
    func configureUI() {
        [   perfumeInfoView ] .forEach { addSubview($0) }
        
        perfumeInfoView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(48)
        }
    }
}
