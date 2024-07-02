//
//  NoAlarmBackgroundView.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 6/30/24.
//

import UIKit

import SnapKit
import Then

class NoItemView: UIView {
    
    // MARK: - Properties
    
    private let iconImageView = UIImageView().then {
        $0.image = UIImage(named: "noLike")
    }
    
    private let titleLabel = UILabel().then {
        $0.font = .customFont(.pretendard_medium, 24)
        $0.setTextWithLineHeight(text: "제목", lineHeight: 42)
    }
    
    private let descriptionLabel = UILabel().then {
        $0.font = .customFont(.pretendard, 16)
        $0.setTextWithLineHeight(text: "설명", lineHeight: 25.6)
    }
    
    // MARK: - Initialize
    
    init(title: String, description: String) {
        super.init(frame: .zero)
    
        titleLabel.text = title
        descriptionLabel.text = description
        
        setAddView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    private func setAddView() {
        [iconImageView, 
         titleLabel,
         descriptionLabel
        ].forEach { addSubview($0) }
    }
    
    private func setConstraints() {
        iconImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.width.equalTo(110)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(iconImageView.snp.bottom).offset(24)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(62)
            make.bottom.equalToSuperview()
        }
    }
}
