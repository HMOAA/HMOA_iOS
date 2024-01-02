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
    
    lazy var perfumeImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.backgroundColor = #colorLiteral(red: 0.8799095154, green: 0.8735057712, blue: 0.87650913, alpha: 1)
    }
    
    lazy var perfumeLikeView = UIView().then {
        $0.layer.cornerRadius = 10
        $0.backgroundColor = .customColor(.gray1)
    }
    
    lazy var perfumeLikeImageView = UIImageView()
    
    lazy var perfumeLikeCountLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_light, size: 12, color: .black)
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
    lazy var topNote = TastingNoteView()
    
    lazy var heartNote = TastingNoteView()
    
    lazy var baseNote = TastingNoteView()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        perfumeLikeView.frame.size = .init(width: 36 + perfumeLikeCountLabel.frame.size.width,
                                           height: 20)
    }
}

// MARK: - Functions
extension PerfumeInfoView {
    
    private  func configureUI() {
        [
            perfumeLikeImageView,
            perfumeLikeCountLabel,
        ]   .forEach { perfumeLikeView.addSubview($0) }
        
        [   perfumeImageView,
            perfumeLikeView,
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
        
        perfumeLikeView.snp.makeConstraints {
            $0.top.equalTo(perfumeImageView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(16)
            $0.height.equalTo(20)
        }
        
        perfumeLikeImageView.snp.makeConstraints { make in
            make.width.height.equalTo(12)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(6)
        }
        
        perfumeLikeCountLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(perfumeLikeImageView.snp.trailing).offset(4)
        }
        
        titleKoreanLabel.snp.makeConstraints {
            $0.top.equalTo(perfumeLikeView.snp.bottom).offset(6)
            $0.leading.equalToSuperview().inset(16)
        }
        
        titleEnglishLabel.snp.makeConstraints {
            $0.top.equalTo(titleKoreanLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().inset(16)
        }
        
        seperatorLine1.snp.makeConstraints {
            $0.top.equalTo(titleEnglishLabel.snp.bottom).offset(22)
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
        
        topNote.noteLabel.text = "TOP"
        heartNote.noteLabel.text = "HEART"
        baseNote.noteLabel.text = "BASE"
        
    }
}
