//
//  PerfumeMiddleInfoView.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/02/04.
//

import UIKit
import SnapKit
import Then
import DropDown
import TagListView

class PerfumeMiddleInfoView: UIView {
    
    // MARK: - Properies
    
    lazy var priceTitleLabel = UILabel().then {
        $0.setLabelUI("가격")
    }
    
    lazy var priceLabel = UILabel().then {
        $0.font = UIFont.customFont(.pretendard, 16)
        $0.text = "211,000원"
    }
    
    lazy var tastingNoteLabel = UILabel().then {
        $0.setLabelUI("테이스팅 노트")
    }
    
    lazy var tastingImageView = UIImageView().then {
        $0.image = UIImage(named: "tasting")
    }

    lazy var topLineView = PerfumeLineView()

    lazy var heartLineView = PerfumeLineView()

    lazy var baseLineView = PerfumeLineView()

    lazy var moreFindUserLabel = UILabel().then {
        $0.setLabelUI("가장 많이 찾아본 사용자")
    }

    lazy var userTagList = TagListView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0)).then {
        $0.setDetailTagListView()
        $0.addTags(["20대", "여성"])
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

// MARK: - Functions

extension PerfumeMiddleInfoView {
    
    func configureUI() {
        
        [   priceTitleLabel,
            priceLabel,
            tastingNoteLabel,
            tastingImageView,
            moreFindUserLabel,
            userTagList,
            topLineView,
            heartLineView,
            baseLineView    ] .forEach { addSubview($0) }
        
        priceTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
        }
        
        priceLabel.snp.makeConstraints {
            $0.top.equalTo(priceTitleLabel.snp.bottom)
            $0.leading.equalToSuperview().inset(20)
        }
        
        tastingNoteLabel.snp.makeConstraints {
            $0.top.equalTo(priceLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(20)
        }
        
        tastingImageView.snp.makeConstraints {
            $0.top.equalTo(tastingNoteLabel.snp.bottom).offset(-20)
            $0.leading.equalToSuperview()
        }
        
        moreFindUserLabel.snp.makeConstraints {
            $0.top.equalTo(tastingImageView.snp.bottom).offset(-20)
            $0.leading.equalToSuperview().inset(20)
        }
        
        userTagList.snp.makeConstraints {
            $0.top.equalTo(moreFindUserLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(20)
        }
        
        topLineView.snp.makeConstraints {
            $0.top.equalTo(tastingNoteLabel.snp.bottom).offset(55)
            $0.leading.equalToSuperview().inset(80)
        }
        
        heartLineView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(80)
            $0.top.equalTo(topLineView.snp.bottom).offset(46)
        }
        
        baseLineView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(80)
            $0.top.equalTo(topLineView.snp.bottom).offset(90)
        }
        
        topLineView.setLabel(label: "Cherry")
        heartLineView.setLabel(label: "Woody")
        baseLineView.setLabel(label: "Floral")
    }
}
