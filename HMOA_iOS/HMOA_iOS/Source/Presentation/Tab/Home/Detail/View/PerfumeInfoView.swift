//
//  PerfumeInfoView.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/02/04.
//

import UIKit
import SnapKit
import Then
class PerfumeInfoView: UIView {
    
    
    // MARK: - Properies
    
    lazy var perfumeImageView = UIImageView()
    
    lazy var perfumeLikeButton = UIButton().then {
        $0.makeLikeButton()
    }
    
    lazy var titleKoreanLabel = UILabel().then {
        $0.font = UIFont.customFont(.pretendard_medium, 20)
    }
    
    lazy var titleEnglishLabel = UILabel().then {
        $0.font = UIFont.customFont(.pretendard, 12)
    }
    
    
    let seperatorLine1 = UIView().then {
        $0.backgroundColor = UIColor.customColor(.gray2)
    }
    
    lazy var priceLabel = UILabel().then {
        $0.font = UIFont.customFont(.pretendard_medium, 16)
    }
    
    lazy var perfumeView30 = EmptyPerfumeView()
    
    
    let seperatorLine2 = UIView().then {
        $0.backgroundColor = UIColor.customColor(.gray2)
    }
    
    lazy var brandView = BrandView()
    
    lazy var tastingLabel = UILabel().then {
        $0.font = UIFont.customFont(.pretendard_medium, 20)
        $0.text = "테이스팅 노트"
    }
    //TODO: singleNoteView 만들기
    lazy var topNote = TastingNoteView(pos: "TOP")
    
    lazy var heartNote = TastingNoteView(pos: "HEART")
    
    lazy var baseNote = TastingNoteView(pos: "BASE")
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Functions
extension PerfumeInfoView {
    
    func configureUI() {
        
        [   perfumeImageView,
            perfumeLikeButton,
            titleEnglishLabel,
            titleKoreanLabel,
            seperatorLine1,
            priceLabel,
            perfumeView30,
            seperatorLine2,
            brandView,
            tastingLabel,
            topNote,
            heartNote,
            baseNote    ] .forEach { addSubview($0) }
        
        perfumeImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalTo(UIScreen.main.bounds.width)
            $0.height.equalTo(360)
        }
        
        perfumeLikeButton.snp.makeConstraints {
            $0.top.equalTo(perfumeImageView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(16)
            $0.height.equalTo(20)
        }
        
        titleKoreanLabel.snp.makeConstraints {
            $0.top.equalTo(perfumeLikeButton.snp.bottom).offset(6)
            $0.leading.equalToSuperview().inset(16)
        }
        
        titleEnglishLabel.snp.makeConstraints {
            $0.top.equalTo(titleKoreanLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().inset(16)
        }
        
        seperatorLine1.snp.makeConstraints {
            $0.top.equalTo(titleEnglishLabel.snp.bottom).offset(46)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.width.equalTo(UIScreen.main.bounds.width - 32)
            $0.height.equalTo(1)
        }
        
        priceLabel.snp.makeConstraints {
            $0.top.equalTo(seperatorLine1.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(16)
        }
        
        perfumeView30.snp.makeConstraints {
            $0.top.equalTo(priceLabel.snp.bottom).offset(18)
            $0.leading.equalToSuperview().inset(16)
            $0.width.equalTo(31)
            $0.height.equalTo(45)
        }

        seperatorLine2.snp.makeConstraints {
            $0.top.equalTo(perfumeView30.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.width.equalTo(UIScreen.main.bounds.width - 32)
            $0.height.equalTo(1)
        }
        
        brandView.snp.makeConstraints {
            $0.top.equalTo(seperatorLine2).inset(48)
            $0.leading.trailing.equalToSuperview().inset(32)
            $0.height.equalTo(68)
        }
        
        tastingLabel.snp.makeConstraints {
            $0.top.equalTo(brandView.snp.bottom).offset(48)
            $0.leading.equalToSuperview().inset(16)
        }
        
        topNote.snp.makeConstraints {
            $0.top.equalTo(tastingLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(60)
        }
        
        heartNote.snp.makeConstraints {
            $0.top.equalTo(topNote.snp.bottom)
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(60)

        }
        
        baseNote.snp.makeConstraints {
            $0.top.equalTo(heartNote.snp.bottom)
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.bottom.equalToSuperview()
            $0.height.equalTo(60)

        }
    }
}
