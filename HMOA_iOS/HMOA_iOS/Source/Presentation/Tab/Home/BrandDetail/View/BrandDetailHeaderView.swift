//
//  BrandDetailHeaderView.swift
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

class BrandDetailHeaderView: UICollectionReusableView, View {
    typealias Reactor = BrandDetailHeaderReactor

    // MARK: - Properties
    var disposeBag = DisposeBag()
    
        
    // MARK: identifier
    static let identifier = "BrandDetailHeaderView"
    
    // MARK: - UI Component
    
    lazy var brandInfoView = UIView().then {
        $0.backgroundColor = .black
    }
    
    lazy var brandImageView = UIImageView().then {
        $0.backgroundColor = .customColor(.gray3)
    }
    
    lazy var koreanLabel = UILabel().then {
        $0.textColor = .white
        $0.font = .customFont(.pretendard_medium, 14)
    }
    
    lazy var englishLabel = UILabel().then {
        $0.textColor = .white
        $0.font = .customFont(.pretendard_medium, 14)
    }
    
    lazy var likeButton = UIButton().then {
        $0.setImage(UIImage(named: "bottomHeart"), for: .normal)
    }
    
    // TODO: - 드롭다운 라이브러리 사용해서 추후에 구현
    lazy var filterButton = UIButton().then {
        $0.titleLabel?.font = .customFont(.pretendard_light, 12)
        $0.setTitleColor(.black, for: .normal)
        $0.setTitle("최신순", for: .normal)
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

extension BrandDetailHeaderView {
    
    // MARK: - bind
    func bind(reactor: BrandDetailHeaderReactor) {
        
        // MARK: - State
        
        // 한글 브랜드명
        reactor.state
            .map { $0.brandInfo.koreanName }
            .distinctUntilChanged()
            .bind(to: koreanLabel.rx.text)
            .disposed(by: disposeBag)
        
        // 영어 브랜드명
        reactor.state
            .map { $0.brandInfo.EnglishName }
            .distinctUntilChanged()
            .bind(to: englishLabel.rx.text)
            .disposed(by: disposeBag)
        
        // 해당 브랜드 좋아요 상태
        reactor.state
            .map { $0.brandInfo.isLikeBrand }
            .distinctUntilChanged()
            .bind(to: likeButton.rx.isSelected)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Configure
    
    func configureUI() {
        
        [   brandInfoView,
            filterButton
        ]   .forEach { addSubview($0) }
        
        [   englishLabel,
            koreanLabel,
            likeButton,
            brandImageView
        ]   .forEach { brandInfoView.addSubview($0) }
        
        
        brandInfoView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(200)
        }
        
        englishLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(16)
            $0.height.equalTo(14)
        }
        
        koreanLabel.snp.makeConstraints {
            $0.top.equalTo(englishLabel.snp.bottom).offset(6)
            $0.leading.equalTo(englishLabel)
            $0.height.equalTo(14)
        }
        
        likeButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(16)
            $0.width.height.equalTo(20)
        }
        
        brandImageView.snp.makeConstraints {
            $0.trailing.bottom.equalToSuperview().inset(16)
            $0.width.height.equalTo(100)
        }
        
        filterButton.snp.makeConstraints {
            $0.top.equalTo(brandInfoView.snp.bottom).offset(16)
            $0.trailing.equalToSuperview().inset(21)
        }
    }
}
