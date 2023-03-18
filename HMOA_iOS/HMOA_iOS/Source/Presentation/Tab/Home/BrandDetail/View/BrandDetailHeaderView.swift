//
//  BrandDetailHeaderView.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/03/18.
//

import UIKit

class BrandDetailHeaderView: UICollectionReusableView {
        
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
        $0.font = .customFont(.pretendard_medium, 14)
    }
    
    lazy var englishLabel = UILabel().then {
        $0.font = .customFont(.pretendard_medium, 14)
    }
    
    lazy var likeButton = UIButton().then {
        $0.setImage(UIImage(named: "drawer"), for: .normal)
    }
    
    // TODO: - 드롭다운 라이브러리 사용해서 추후에 구현
    lazy var filterButton = UIButton().then {
        $0.titleLabel?.font = .customFont(.pretendard_light, 12)
        $0.setTitleColor(.black, for: .normal)
        $0.setTitle("최신순", for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BrandDetailHeaderView {
    
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
            $0.width.equalTo(360)
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
        }
        
        brandInfoView.snp.makeConstraints {
            $0.trailing.bottom.equalToSuperview().inset(16)
            $0.width.height.equalTo(100)
        }
        
        filterButton.snp.makeConstraints {
            $0.top.equalTo(brandInfoView.snp.bottom).offset(16)
            $0.trailing.equalToSuperview().inset(21)
        }
    }
}
