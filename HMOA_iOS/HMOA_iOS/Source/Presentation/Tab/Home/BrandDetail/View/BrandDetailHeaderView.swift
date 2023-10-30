//
//  BrandDetailHeaderView.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/03/18.
//

import UIKit
import SnapKit
import Then

class BrandDetailHeaderView: UICollectionReusableView {
        
    // MARK: identifier
    static let identifier = "BrandDetailHeaderView"
    
    // MARK: - UI Component
    
    lazy var brandInfoView = UIView().then {
        $0.backgroundColor = .black
    }
    
    lazy var brandImageView = UIImageView().then {
        $0.layer.borderWidth = 3
        $0.layer.borderColor = UIColor.customColor(.gray3).cgColor
    }
    
    lazy var koreanLabel = UILabel().then {
        $0.textColor = .white
        $0.font = .customFont(.pretendard_medium, 14)
    }
    
    lazy var englishLabel = UILabel().then {
        $0.textColor = .white
        $0.font = .customFont(.pretendard_medium, 14)
    }
    
    lazy var sortButton = UIButton().then {
        $0.setTitleColor(.customColor(.gray3), for: .normal)
        $0.titleLabel?.font = .customFont(.pretendard_light, 12)
        $0.setTitleColor(.black, for: .selected)
        $0.setTitle("좋아요순", for: .normal)
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
    
    // MARK: - Configure
    
    func configureUI() {
        
        [   brandInfoView,
            sortButton
        ]   .forEach { addSubview($0) }
        
        [   englishLabel,
            koreanLabel,
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
        
        brandImageView.snp.makeConstraints {
            $0.trailing.bottom.equalToSuperview().inset(16)
            $0.width.height.equalTo(100)
        }
        
        sortButton.snp.makeConstraints {
            $0.top.equalTo(brandInfoView.snp.bottom).offset(16)
            $0.trailing.equalToSuperview()
            $0.width.equalTo(80)
        }
    }
}
