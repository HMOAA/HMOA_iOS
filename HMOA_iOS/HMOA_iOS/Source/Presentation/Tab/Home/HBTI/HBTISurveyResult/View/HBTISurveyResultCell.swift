//
//  HBTISurveyResultCell.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 8/13/24.
//

import UIKit

import Kingfisher
import Then
import SnapKit

class HBTISurveyResultCell: UICollectionViewCell {
    
    static let identifier = "HBTISurveyResultCell"
    
    // MARK: - UI Components
    
    private let bannerImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    private let nameLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_bold, size: 16, color: .white)
    }
    
    private let descriptionLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_light, size: 12, color: .white)
        $0.setTextWithLineHeight(text: "설명\n2줄", lineHeight: 15)
        $0.numberOfLines = 2
        $0.lineBreakStrategy = .hangulWordPriority
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setAddView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Function
    
    private func setUI() {
        backgroundColor = .black
    }
    
    private func setAddView() {
        [
            bannerImageView,
            nameLabel,
            descriptionLabel
        ].forEach { addSubview($0) }
    }
    
    private func setConstraints() {
        bannerImageView.snp.makeConstraints { make in
            let availableWidth = layer.frame.width
            let imageHeight = (236.0 / 249.0) * availableWidth
            
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(236)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(bannerImageView.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(7)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(24)
        }
    }
    
    func configureCell(note: HBTISurveyResultNote) {
//        bannerImageView.kf.setImage(with: URL(string: note.photoURL))
        bannerImageView.backgroundColor = .random
        nameLabel.text = note.name
        descriptionLabel.text = note.content
    }
}
