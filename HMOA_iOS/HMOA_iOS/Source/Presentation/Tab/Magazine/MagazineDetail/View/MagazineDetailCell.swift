//
//  MagazineDetailTitleCell.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 3/5/24.
//

import UIKit
import Then
import SnapKit

class MagazineDetailCell: UICollectionViewCell {
    
    static let identifier = "MagazineDetailCell"
    
    let lineHeight: CGFloat = 1 / UIScreen.main.scale
    
    // MARK: UI Components
    private let sloganLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard, size: 24, color: .black)
    }
    
    private let perfumeNameLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_bold, size: 24, color: .black)
    }
    
    private let dateLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard, size: 14, color: .gray3)
    }
    
    private let viewCountStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 5
        $0.alignment = .center
    }
    
    private let viewCountImageView = UIImageView().then {
        $0.image = UIImage(named: "viewCount")
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    private let viewCountLabel = UILabel().then {
        $0.setLabelUI("12,345", font: .pretendard, size: 12, color: .gray3)
    }
    
    private let coverImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    private let descriptionLabel = UILabel().then {
        $0.setLabelUI("" , font: .pretendard, size: 14, color: .gray3)
        $0.lineBreakMode = .byCharWrapping
        $0.numberOfLines = 0
    }
    
    private let separatorLine1 = UIView().then {
        $0.backgroundColor = .customColor(.gray1)
    }
    
    private let contentLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard, size: 14, color: .black)
        $0.lineBreakMode = .byCharWrapping
        $0.numberOfLines = 0
    }
    
    // TODO: TagView 추가
    
    private let separatorLine2 = UIView().then {
        $0.backgroundColor = .customColor(.gray1)
    }
    
    private let likeStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 55
        $0.alignment = .center
        $0.distribution = .equalSpacing
    }
    
    private let likeAskingLabel = UILabel().then {
        $0.setLabelUI("매거진이 유용한 정보였다면", font: .pretendard, size: 16, color: .black)
    }
    
    private let likeButtomStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 12
        $0.alignment = .center
        $0.distribution = .equalSpacing
    }
    
    private let likeButton = UIButton().then {
        $0.setImage(UIImage(named: "thumbsUp"), for: .normal)
    }
    
    private let likeCountLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard, size: 14, color: .gray2)
    }
    
    private let separatorLine3 = UIView().then {
        $0.backgroundColor = .customColor(.gray1)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAddView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAddView() {
        [sloganLabel, perfumeNameLabel, dateLabel, viewCountStackView,
         coverImageView, descriptionLabel, separatorLine1, contentLabel,
         separatorLine2, likeStackView, separatorLine3].forEach { addSubview($0) }
        
        [viewCountImageView, viewCountLabel].forEach { viewCountStackView.addArrangedSubview($0) }
        
        [likeAskingLabel, likeButtomStackView].forEach { likeStackView.addArrangedSubview($0) }
        
        [likeButton, likeCountLabel].forEach { likeButtomStackView.addArrangedSubview($0) }
    }
    
    private func setConstraints() {
        sloganLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(17)
        }
        
        perfumeNameLabel.snp.makeConstraints { make in
            make.top.equalTo(sloganLabel.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(17)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(perfumeNameLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(17)
        }
        
        viewCountStackView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(52)
            make.leading.trailing.equalToSuperview().inset(17)
        }
        
        coverImageView.snp.makeConstraints { make in
            make.top.equalTo(viewCountStackView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(coverImageView.snp.width).multipliedBy(452.0 / 360.0)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(coverImageView.snp.bottom).offset(44)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        separatorLine1.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(48)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(lineHeight)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(separatorLine1.snp.bottom).offset(48)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        separatorLine2.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(48)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(lineHeight)
        }
        
        likeStackView.snp.makeConstraints { make in
            make.top.equalTo(separatorLine2.snp.bottom).offset(63)
            make.leading.equalToSuperview().inset(40)
            make.trailing.equalToSuperview().inset(52)
        }
        
        separatorLine3.snp.makeConstraints { make in
            make.top.equalTo(likeStackView.snp.bottom).offset(57)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(5)
        }
        
    }
    
    func configureCell(_ magazine: Magazine) {
        sloganLabel.text = magazine.slogan
        perfumeNameLabel.text = magazine.perfumeName
        dateLabel.text = magazine.releaseDate
        coverImageView.backgroundColor = .random
        descriptionLabel.text = magazine.longDescription
        contentLabel.text = magazine.content
        likeCountLabel.text = String(magazine.likeCount)
    }
}
