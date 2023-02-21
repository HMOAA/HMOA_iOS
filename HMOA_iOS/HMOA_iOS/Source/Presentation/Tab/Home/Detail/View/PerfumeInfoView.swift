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
    
    lazy var perfumLikeView = LikeView()
    
    lazy var titleKoreanLabel = UILabel().then {
        $0.text = "우드 세이지 앤 씨 솔트 코롱"
        $0.font = UIFont.customFont(.pretendard_medium, 20)
    }
    
    lazy var titleEnglishLabel = UILabel().then {
        $0.text = "Wood Sage & Sea Salt Cologne"
        $0.font = UIFont.customFont(.pretendard, 12)
    }
    
    lazy var keywordTagListView = TagListView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 32, height: 0)).then {
        $0.borderColor = UIColor.customColor(.gray3)
        $0.cornerRadius = 10
        $0.borderWidth = 0.2
        $0.tagBackgroundColor = .white
        $0.textColor = UIColor.customColor(.gray3)
        $0.alignment = .left
        $0.textFont = UIFont.customFont(.pretendard, 10)
        $0.paddingY = 5
        $0.paddingX = 12
        $0.addTags(["우디한", "자연의"])
    }
    
    let seperatorLine1 = UIView().then {
        $0.backgroundColor = UIColor.customColor(.gray2)
    }
    
    lazy var priceLabel = UILabel().then {
        $0.font = UIFont.customFont(.pretendard_medium, 16)
        $0.text = "₩218,000 ~"
    }
    
    lazy var perfumeView30 = EmptyPerfumeView("30ml")
    
    lazy var ageLabel = UILabel().then {
        $0.font = UIFont.customFont(.pretendard_medium, 14)
        $0.text = "20"
    }
    
    lazy var ageNearLabel = UILabel().then {
        $0.font = UIFont.customFont(.pretendard, 14)
        $0.text = "대"
    }
    
    lazy var gendarLabel = UILabel().then {
        $0.font = UIFont.customFont(.pretendard_medium, 14)
        $0.text = "여성"
    }

    lazy var gendarNearLabel = UILabel().then {
        $0.font = UIFont.customFont(.pretendard, 14)
        $0.text = "이 가장 많이 검색한 제품"
    }
    
    let seperatorLine2 = UIView().then {
        $0.backgroundColor = UIColor.customColor(.gray2)
    }
    
    lazy var brandView = BrandView()
    
    lazy var productInfoTitleLabel = UILabel().then {
        $0.font = UIFont.customFont(.pretendard_medium, 16)
        $0.text = "상품설명"
    }
    
    lazy var productInfoContentLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.font = UIFont.customFont(.pretendard, 14)
        $0.text = "바람부는 해안을 따라 걸으며 일상을 벗어나보세요. 하얗게 부서지는 파도, 소금기를 머금은 신선한 바다 공기. 험준한 절벽에서 느껴지는 투박한 자연의 향기와 세이지의 우디한 흙 내음이 어우러져 자유롭고 활기찬 에너지와 즐거움이 가득합니다.바람부는 해안을 따라 걸으며 일상을 벗어나보세요. 하얗게 부서지는 파도, 소금기를 머금은 신선한 바다 공기. 험준한 절벽에서 느껴지는 투박한 자연의 향기와 세이지의 우디한 흙 내음이 어우러져 자유롭고 활기찬 에너지와 즐거움이 가득합니다.바람부는 해안을 따라 걸으며 일상을 벗어나보세요. 하얗게 부서지는 파도, 소금기를 머금은 신선한 바다 공기. 험준한 절벽에서 느껴지는 투박한 자연의 향기와 세이지의 우디한 흙 내음이 어우러져 자유롭고 활기찬 에너지와 즐거움이 가득합니다.바람부는 해안을 따라 걸으며 일상을 벗어나보세요. 하얗게 부서지는 파도, 소금기를 머금은 신선한 바다 공기. 험준한 절벽에서 느껴지는 투박한 자연의 향기와 세이지의 우디한 흙 내음이 어우러져 자유롭고 활기찬 에너지와 즐거움이 가득합니다.바람부는 해안을 따라 걸으며 일상을 벗어나보세요. 하얗게 부서지는 파도, 소금기를 머금은 신선한 바다 공기. 험준한 절벽에서 느껴지는 투박한 자연의 향기와 세이지의 우디한 흙 내음이 어우러져 자유롭고 활기찬 에너지와 즐거움이 가득합니다.바람부는 해안을 따라 걸으며 일상을 벗어나보세요. 하얗게 부서지는 파도, 소금기를 머금은 신선한 바다 공기. 험준한 절벽에서 느껴지는 투박한 자연의 향기와 세이지의 우디한 흙 내음이 어우러져 자유롭고 활기찬 에너지와 즐거움이 가득합니다."
    }
    
    lazy var tastingLabel = UILabel().then {
        $0.font = UIFont.customFont(.pretendard_medium, 16)
        $0.text = "테이스팅 노트"
    }
    
    lazy var topNote = TastingNoteView(name: "암브레트 씨", pos: "TOP")
    
    lazy var heartNote = TastingNoteView(name: "씨 쏠트", pos: "HEART")
    
    lazy var baseNote = TastingNoteView(name: "세이지", pos: "BASE")
    
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
            perfumLikeView,
            titleEnglishLabel,
            titleKoreanLabel,
            keywordTagListView,
            seperatorLine1,
            priceLabel,
            perfumeView30,
            ageLabel,
            ageNearLabel,
            gendarLabel,
            gendarNearLabel,
            seperatorLine2,
            brandView,
            productInfoTitleLabel,
            productInfoContentLabel,
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
        
        perfumLikeView.snp.makeConstraints {
            $0.top.equalTo(perfumeImageView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(16)
            $0.width.equalTo(60)
            $0.height.equalTo(20)
        }
        
        titleKoreanLabel.snp.makeConstraints {
            $0.top.equalTo(perfumLikeView.snp.bottom).offset(6)
            $0.leading.equalToSuperview().inset(16)
        }
        
        titleEnglishLabel.snp.makeConstraints {
            $0.top.equalTo(titleKoreanLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().inset(16)
        }
        
        keywordTagListView.snp.makeConstraints {
            $0.top.equalTo(titleEnglishLabel.snp.bottom).offset(12)
            $0.leading.equalToSuperview().inset(16)
        }
        
        seperatorLine1.snp.makeConstraints {
            $0.top.equalTo(keywordTagListView.snp.bottom).offset(16)
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

        ageLabel.snp.makeConstraints {
            $0.top.equalTo(perfumeView30.snp.bottom).offset(12)
            $0.leading.equalToSuperview().inset(16)
        }

        ageNearLabel.snp.makeConstraints {
            $0.top.equalTo(ageLabel)
            $0.leading.equalTo(ageLabel.snp.trailing).offset(1)
        }

        gendarLabel.snp.makeConstraints {
            $0.top.equalTo(ageLabel)
            $0.leading.equalTo(ageNearLabel.snp.trailing).offset(4)
        }

        gendarNearLabel.snp.makeConstraints {
            $0.top.equalTo(ageLabel)
            $0.leading.equalTo(gendarLabel.snp.trailing).offset(1)
        }

        seperatorLine2.snp.makeConstraints {
            $0.top.equalTo(ageLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.width.equalTo(UIScreen.main.bounds.width - 32)
            $0.height.equalTo(1)
        }
        
        brandView.snp.makeConstraints {
            $0.top.equalTo(seperatorLine2).inset(48)
            $0.leading.trailing.equalToSuperview().inset(32)
            $0.height.equalTo(68)
        }
        
        
        productInfoTitleLabel.snp.makeConstraints {
            $0.top.equalTo(brandView.snp.bottom).offset(48)
            $0.leading.equalToSuperview().inset(16)
        }
        
        productInfoContentLabel.snp.makeConstraints {
            $0.top.equalTo(productInfoTitleLabel.snp.bottom).offset(12)

            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        tastingLabel.snp.makeConstraints {
            $0.top.equalTo(productInfoContentLabel.snp.bottom).offset(48)
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
