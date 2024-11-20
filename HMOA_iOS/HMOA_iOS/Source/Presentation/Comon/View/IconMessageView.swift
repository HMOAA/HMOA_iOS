//
//  NoAlarmBackgroundView.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 6/30/24.
//

import UIKit

import SnapKit
import Then

class IconMessageView: UIView {
    
    // MARK: - Components
    
    private let iconImageView = UIImageView().then {
        $0.image = UIImage(named: "AppIcon_Black")
    }
    
    private let titleLabel = UILabel().then {
        $0.font = .customFont(.pretendard_bold, 22)
        $0.setTextWithLineHeight(text: "제목", lineHeight: 28)
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    private let descriptionLabel = UILabel().then {
        $0.font = .customFont(.pretendard, 16)
        $0.setTextWithLineHeight(text: "설명", lineHeight: 25.6)
    }
    
    // MARK: - Initialize
    
    init(title: String? = nil, description: String? = nil, iconWidth: CGFloat, titleOffSet: CGFloat = 24, descriptionOffset: CGFloat = 62) {
        super.init(frame: .zero)
    
        titleLabel.text = title
        descriptionLabel.text = description
        
        setAddView()
        setConstraints(iconWidth, titleOffSet, descriptionOffset)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    private func setAddView() {
        var subViews: [UIView] = [iconImageView]
        
        if titleLabel.text != "제목" {
            subViews.append(titleLabel)
        }
        
        if descriptionLabel.text != "설명" {
            subViews.append(descriptionLabel)
        }
        
        subViews.forEach { addSubview($0) }
    }
    
    private func setConstraints(_ iconWidth: CGFloat, _ titleOffset: CGFloat, _ descriptionOffset: CGFloat) {
        iconImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.width.height.equalTo(iconWidth)
        }
        
        if titleLabel.text != "제목" {
            titleLabel.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalTo(iconImageView.snp.bottom).offset(titleOffset)
            }
        }
        
        if descriptionLabel.text != "설명" {
            descriptionLabel.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalTo(titleLabel.snp.bottom).offset(descriptionOffset)
                make.bottom.equalToSuperview()
            }
        }
    }
}
