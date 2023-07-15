//
//  BrandDetailCollectionViewCell.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/03/18.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import ReactorKit

class BrandDetailCollectionViewCell: UICollectionViewCell, View {
    typealias Reactor = BrandDetailCellReactor

    var disposeBag = DisposeBag()
    
    
    static let identifier = "BrandDetailCollectionViewCell"

    // MARK: - UI Component
    
    lazy var productImageView = UIImageView().then {
        $0.backgroundColor = .customColor(.gray3)
    }
    
    var titleLabel = UILabel().then {
        $0.font = .customFont(.pretendard_medium, 14)
    }
    
    var contentLabel = UILabel().then {
        $0.numberOfLines = 2
        $0.font = .customFont(.pretendard, 12)
    }
    
    lazy var likeButton = UIButton().then {
        $0.setImage(UIImage(named: "heart"), for: .normal)
        $0.setImage(UIImage(named: "heart_fill"), for: .selected)
    }
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BrandDetailCollectionViewCell {
    
    // MARK: - Bind
    
    func bind(reactor: BrandDetailCellReactor) {
        
        // MARK: - Action
        likeButton.rx.tap
            .map { Reactor.Action.didTapPerfumeLikeButton(self.likeButton.isSelected) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: - State
        
        // 향수 브랜드명
        reactor.state
            .map { $0.perfume.titleName }
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        // 향수 품명
        reactor.state
            .map { $0.perfume.content }
            .bind(to: contentLabel.rx.text)
            .disposed(by: disposeBag)
        
        // 향수 좋아요 상태
        reactor.state
            .map { $0.perfume.isLikePerfume }
            .bind(to: likeButton.rx.isSelected)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Configure
    func configureUI() {
        [   productImageView,
            titleLabel,
            contentLabel,
            likeButton
        ]   .forEach { addSubview($0) }
        
        
        productImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(productImageView.snp.width)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(productImageView.snp.bottom).offset(12)
            $0.leading.equalToSuperview()
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(6)
            $0.leading.trailing.equalToSuperview()
        }
        
        likeButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel)
            $0.trailing.equalToSuperview()
        }
    }
    
    func updateCell(_ product: Perfume) {
//        self.productImageView.image = product.image
        self.titleLabel.text = product.titleName
        self.contentLabel.text = product.content
    }
    
    func bindUI(_ data: Perfume) {
        titleLabel.text = data.titleName
        contentLabel.text = data.content
        likeButton.isSelected = data.isLikePerfume
    }
}



