//
//  BrandView.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/02/11.
//

import UIKit
import SnapKit
import Then

class BrandView: UIView {
    
    
    // MARK: - Properties
    
    lazy var brandImageView = UIImageView().then {
        $0.layer.borderColor = UIColor.customColor(.brandBorderColor).cgColor
        $0.layer.borderWidth = 1
        $0.contentMode = .scaleAspectFit
        $0.backgroundColor = .white
        $0.image = UIImage(named: "brand")
    }
    
    lazy var brandEnglishLabel = UILabel().then {
        $0.textColor = .white
        $0.font = UIFont.customFont(.pretendard, 14)
        $0.text = "JO MALONE LONDON"
    }
    
    lazy var brandKoreanLabel = UILabel().then {
        $0.textColor = .white
        $0.font = UIFont.customFont(.pretendard, 14)
        $0.text = "조말론 런던"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BrandView {
    
    func configureUI() {
        
        backgroundColor = .black
        
        [   brandImageView,
            brandEnglishLabel,
            brandKoreanLabel
        ]   .forEach { addSubview($0) }
        
        brandImageView.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.width.height.equalTo(68)
        }
        
        brandEnglishLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.equalTo(brandImageView.snp.trailing).offset(12)
        }
        
        brandKoreanLabel.snp.makeConstraints {
            $0.top.equalTo(brandEnglishLabel.snp.bottom).offset(6)
            $0.leading.equalTo(brandEnglishLabel)
        }

    }
}
