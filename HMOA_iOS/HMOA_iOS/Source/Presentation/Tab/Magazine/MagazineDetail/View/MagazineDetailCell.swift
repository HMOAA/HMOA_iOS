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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAddView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAddView() {
        [sloganLabel, perfumeNameLabel, dateLabel,
         viewCountStackView, coverImageView, descriptionLabel].forEach { addSubview($0) }
        
        [viewCountImageView, viewCountLabel].forEach { viewCountStackView.addArrangedSubview($0) }
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
            make.leading.trailing.equalToSuperview().inset(15)
            make.bottom.equalToSuperview()
        }
        
    }
    
    func configureCell(_ magazine: Magazine) {
        sloganLabel.text = magazine.slogan
        perfumeNameLabel.text = magazine.perfumeName
        dateLabel.text = magazine.releaseDate
        coverImageView.backgroundColor = .random
        descriptionLabel.text = magazine.longDescription
    }
}
