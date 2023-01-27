//
//  NewsCellFooterView.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/01/27.
//

import UIKit
import SnapKit
import Then
import TagListView

class NewsCellFooterView: UICollectionReusableView {
    
    // MARK: - identifier
    
    static let identifer = "NewsCellFooterView"
    
    // MARK: - Properties
    
    lazy var titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 24, weight: .medium)
        $0.text = "샤넬이 사랑한 모든 것"
    }
    
    lazy var subLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
        $0.text = "Qui Qu'a Vu Coco, 누가 코코를 보았나?"
    }
    
    lazy var dateLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 10)
        $0.textColor = UIColor.customColor(.labelGrayColor)
        $0.text = "JUL.08.2022"
    }
    
    lazy var tagList = TagListView(frame: CGRect(x: 0, y: 0, width: 125, height: 200)).then {
        $0.textFont = UIFont.customFont(.pretendard, 12)
        $0.addTags(["샤넬", "히스토리"])
        $0.alignment = .left
        $0.textColor = .black
        $0.tagBackgroundColor = .white
        $0.borderWidth = 0.2
        $0.borderColor = .black
        $0.paddingY = 10
        $0.paddingX = 13
        $0.cornerRadius = 15
    }
    
    // MARK: - Lifecycle
    override func layoutSubviews() {
        configureUI()
    }
}

// MARK: - Functions

extension NewsCellFooterView {
    
    func configureUI() {
        
        [ titleLabel, subLabel, tagList, dateLabel ] .forEach { addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(11)
            $0.leading.equalToSuperview().inset(20)
            $0.height.equalTo(30)
        }
        
        subLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(20)
            $0.height.equalTo(30)
        }
        
        tagList.snp.makeConstraints {
            $0.top.equalTo(subLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(20)
        }
        
        dateLabel.snp.makeConstraints {
            $0.centerY.equalTo(tagList)
            $0.leading.equalTo(tagList.snp.trailing).offset(10)
        }
    }
}
