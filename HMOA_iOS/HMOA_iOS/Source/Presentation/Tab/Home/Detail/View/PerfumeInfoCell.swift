//
//  PerfumeInfoCell.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/02/05.
//

import UIKit
import SnapKit
import Then
import Kingfisher

class PerfumeInfoCell: UICollectionViewCell {
    
    // MARK: - identifier
    
    static let identifier = "PerfumeInfoCell"

    // MARK: - View
    
    let perfumeInfoView = PerfumeInfoView()
    
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

extension PerfumeInfoCell {
    
    // MARK: - Bind
    
    
    func configureUI() {
        [   perfumeInfoView ] .forEach { addSubview($0) }
        
        perfumeInfoView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(48)
        }
    }
    
    func setLikeButtonText(_ text: String) -> AttributedString {
        var attri = AttributedString.init(text)
        attri.font = .customFont(.pretendard_light, 12)
        
        return attri
    }
    
    func updateCell(_ item: FirstDetail) {
        perfumeInfoView.perfumeLikeImageView.image = !item.liked ? UIImage(named: "heart") : UIImage(named: "heart_fill")
        perfumeInfoView.perfumeLikeCountLabel.text = "\(item.heartNum)"
        perfumeInfoView.perfumeImageView.kf.setImage(with: URL(string: item.perfumeImageUrl)!)
        perfumeInfoView.titleKoreanLabel.text = item.koreanName
        perfumeInfoView.titleEnglishLabel.text = item.englishName
        perfumeInfoView.priceLabel.text = "₩\(numberFormatter(item.price))"
        perfumeInfoView.topNote.nameLabel.text = item.topNote
        perfumeInfoView.heartNote.nameLabel.text = item.heartNote
        perfumeInfoView.baseNote.nameLabel.text = item.baseNote
        perfumeInfoView.brandView.brandEnglishLabel.text = item.brandEnglishName
        perfumeInfoView.brandView.brandKoreanLabel.text = item.brandName
        perfumeInfoView.brandView.brandImageView.kf.setImage(with: URL(string: item.brandImgUrl))
        setVolume(item)
        
        
    }
    
    func numberFormatter(_ number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        return numberFormatter.string(for: number)!
    }

    func setVolume(_ item: FirstDetail ) {
        switch item.priceVolume {
        case 1:
            perfumeInfoView.perfumeView30.capacityLabel1.text = "\(item.volume[0])ml"
            perfumeInfoView.perfumeView30.capacityLabel1.textColor = .black
            perfumeInfoView.perfumeView30.perfumeImageView1.tintColor = .black
        case 2:
            perfumeInfoView.perfumeView30.capacityLabel1.text = "\(item.volume[0])ml"
            perfumeInfoView.perfumeView30.capacityLabel2.text = "\(item.volume[1])ml"
            perfumeInfoView.perfumeView30.perfumeImageView2.isHidden = false
            perfumeInfoView.perfumeView30.capacityLabel2.textColor = .black
            perfumeInfoView.perfumeView30.perfumeImageView2.tintColor = .black
        case 3:
            perfumeInfoView.perfumeView30.capacityLabel1.text = "\(item.volume[0])ml"
            perfumeInfoView.perfumeView30.capacityLabel2.text = "\(item.volume[1])ml"
            perfumeInfoView.perfumeView30.capacityLabel3.text = "\(item.volume[2])ml"
            perfumeInfoView.perfumeView30.perfumeImageView2.isHidden = false
            perfumeInfoView.perfumeView30.perfumeImageView3.isHidden = false
            perfumeInfoView.perfumeView30.capacityLabel3.textColor = .black
            perfumeInfoView.perfumeView30.perfumeImageView3.tintColor = .black
        default: break
        }
    }
}
