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
import RxSwift

class PerfumeInfoCell: UICollectionViewCell {
    
    // MARK: - identifier
    
    static let identifier = "PerfumeInfoCell"

    // MARK: - View
    
    let perfumeInfoView = PerfumeInfoView()
    var disposeBag = DisposeBag()
    lazy var noteViews = [perfumeInfoView.topNote,
                         perfumeInfoView.heartNote,
                         perfumeInfoView.baseNote]
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
}

// MARK: - Functions

extension PerfumeInfoCell {
    
    func configureUI() {
        [   perfumeInfoView ] .forEach { addSubview($0) }
        
        perfumeInfoView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(48)
        }
        
        noteViews.forEach { $0.isHidden = true }
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
        perfumeInfoView.priceLabel.text = "₩\(numberFormatter(item.price))"
        perfumeInfoView.brandView.brandEnglishLabel.text = item.brandEnglishName
        perfumeInfoView.brandView.brandKoreanLabel.text = item.brandName
        perfumeInfoView.brandView.brandImageView.kf.setImage(with: URL(string: item.brandImgUrl))
        
        setVolume(item)
        updateNote(item)
        
    }
    
    func updateNote(_ item: FirstDetail) {
        switch item.sortType {
        case 0:
            noteViews.forEach { $0.snp.removeConstraints() }
            perfumeInfoView.tastingLabel.snp.removeConstraints()
            perfumeInfoView.tastingLabel.isHidden = true
            
        case 1:
            let notes = [item.topNote!]
            updateNoteViews(noteCount: 1, item: item, notes: notes)
            
            noteViews[1].snp.removeConstraints()
            noteViews[2].snp.removeConstraints()
            
            remakeTopNoteConstraints()
            
        case 2:
            let notes = [item.topNote!, item.heartNote!]
            updateNoteViews(noteCount: 2, item: item, notes: notes)
            
            noteViews[2].snp.removeConstraints()
            remakeUntilHeartNoteConstants()
            
        case 3:
            let notes = [item.topNote!, item.heartNote!, item.baseNote!]
            updateNoteViews(noteCount: 3, item: item, notes: notes)
            
        default: break
        }
    }
    
    func updateNoteViews(noteCount: Int, item: FirstDetail, notes: [String]) {
        for i in 0..<noteCount {
            noteViews[i].noteImageView.image = UIImage(named: "note\(item.notePhotos[i])")
            noteViews[i].isHidden = false
            noteViews[i].posLabel.text = notes[i]
        }
    }
    func remakeTopNoteConstraints() {
        noteViews[0].snp.remakeConstraints {
            $0.top.equalTo(perfumeInfoView.tastingLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(60)
        }
    }
    
    func remakeUntilHeartNoteConstants() {
        remakeTopNoteConstraints()
        noteViews[1].snp.remakeConstraints {
            $0.top.equalTo(perfumeInfoView.topNote.snp.bottom)
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(60)
            $0.bottom.equalToSuperview().inset(16)
        }
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
