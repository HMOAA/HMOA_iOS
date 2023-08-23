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
import Kingfisher
import RxSwift

class PerfumeInfoCell: UICollectionViewCell, View {
    
    typealias Reactor = PerfumeInfoViewReactor
    
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
    
    // MARK: - Bind
    
    func bind(reactor: PerfumeInfoViewReactor) {

        // MARK: - Ation

        // 향수 좋아요 버튼 클릭
        perfumeInfoView.perfumeLikeButton.rx.tap
            .map { Reactor.Action.didTapPerfumeLikeButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        // 향수 브랜드 좋아요 버튼 클릭
        perfumeInfoView.brandView.likeButton.rx.tap
            .do(onNext: { print("Clicked")} )
            .map { Reactor.Action.didTapBrandLikeButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        // MARK: - State

        // 향수 좋아요 상태 변경
        reactor.state
            .map { $0.isLikePerfume }
            .distinctUntilChanged()
            .bind(to:
                    perfumeInfoView.perfumeLikeButton.rx.isSelected)
            .disposed(by: disposeBag)

        // 향수 브랜드 좋아요 상태 변경
        reactor.state
            .map { $0.isLikeBrand }
            .distinctUntilChanged()
            .bind(to: perfumeInfoView.brandView.likeButton.rx.isSelected)
            .disposed(by: disposeBag)

        // 향수 좋아요 개수 변경
        reactor.state
            .map { $0.likeCount }
            .distinctUntilChanged()
            .map { String($0) }
            .bind(onNext: {
                self.perfumeInfoView.perfumeLikeButton.configuration?.attributedTitle = self.setLikeButtonText($0)
            })
            .disposed(by: disposeBag)
    }
    
    func configureUI() {
        [   perfumeInfoView ] .forEach { addSubview($0) }
        
        perfumeInfoView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(48)
        }
    }
    
    func setLikeButtonText(_ text: String) -> AttributedString {
        var attri = AttributedString.init(text)
        attri.font = .customFont(.pretendard_light, 12)
        
        return attri
    }
    
    func updateCell(_ item: Detail, _ image: String) {
        perfumeInfoView.perfumeImageView.kf.setImage(with: URL(string: image)!)
        perfumeInfoView.titleKoreanLabel.text = item.koreanName
        perfumeInfoView.titleEnglishLabel.text = item.englishName
        perfumeInfoView.priceLabel.text = "\(item.price)"
        perfumeInfoView.topNote.nameLabel.text = item.topNote
        perfumeInfoView.heartNote.nameLabel.text = item.heartNote
        perfumeInfoView.baseNote.nameLabel.text = item.baseNote
    }
}
