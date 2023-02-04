//
//  PerfumeInfoView.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/02/04.
//

import UIKit
import SnapKit
import Then
import TagListView

class PerfumeInfoView: UIView {
    
    
    // MARK: - Properies
    
    lazy var perfumeImageView = UIImageView().then {
        $0.image = UIImage(named: "jomalon")
    }
    
    lazy var titleEnglishLabel = UILabel().then {
        $0.text = "Blackberry & Bar Cologne"
        $0.font = UIFont.customFont(.pretendard, 16)
    }
    
    lazy var titleKoreanLabel = UILabel().then {
        $0.text = "블랙베리 앤 베이 코롱"
        $0.font = UIFont.customFont(.pretendard, 16)
    }
    
    lazy var keywordTagListView = TagListView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 40, height: 0)).then {
        
        $0.borderColor = .white
        $0.cornerRadius = 15
        $0.borderWidth = 0.2
        $0.tagBackgroundColor = UIColor.customColor(.searchBarColor)
        $0.textColor = .black
        $0.alignment = .left
        $0.textFont = UIFont.customFont(.pretendard, 12)
        $0.paddingY = 8
        $0.paddingX = 10
        $0.addTags(["#형용사", "키워드"])
    }
    
    
    // MARK: - Lifecycle
    override func layoutSubviews() {
        configureUI()
    }
}

// MARK: - Functions
extension PerfumeInfoView {
    
    func configureUI() {
        [   perfumeImageView,
            titleEnglishLabel,
            titleKoreanLabel,
            keywordTagListView  ] .forEach { addSubview($0) }
        
        perfumeImageView.backgroundColor = .blue
        
        perfumeImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.height.width.equalTo(231)
        }
        
        titleEnglishLabel.snp.makeConstraints {
            $0.top.equalTo(perfumeImageView.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(20)
        }
        
        titleKoreanLabel.snp.makeConstraints {
            $0.top.equalTo(titleEnglishLabel.snp.bottom)
            $0.leading.equalToSuperview().inset(20)
        }
        
        keywordTagListView.snp.makeConstraints {
            $0.top.equalTo(titleKoreanLabel.snp.bottom).offset(15)
            $0.leading.equalToSuperview().inset(20)
        }
    }
}
