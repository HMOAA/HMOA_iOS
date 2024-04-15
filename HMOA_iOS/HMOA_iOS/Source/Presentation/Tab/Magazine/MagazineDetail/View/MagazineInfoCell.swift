//
//  MagazinePreviewCell.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 3/19/24.
//

import UIKit
import Then
import SnapKit

class MagazineInfoCell: UICollectionViewCell {
    
    static let identifier = "MagazineInfoCell"
    
    // 향수 이름 라벨
    private let titleLabel = UILabel().then {
        $0.setLabelUI("제목", font: .pretendard_bold, size: 24, color: .black)
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
        $0.setLineSpacing(lineSpacing: 3)
    }
    
    // 발행 날짜 라벨
    private let dateLabel = UILabel().then {
        $0.setLabelUI("2024", font: .pretendard_medium, size: 14, color: .gray3)
    }
    
    // 조회수를 표시하기 위한 스택 뷰
    private let viewCountStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 5
        $0.alignment = .center
    }
    
    // 조회수 아이콘 이미지 뷰
    private let viewCountImageView = UIImageView().then {
        $0.image = UIImage(named: "viewCount")
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    // 조회수 라벨
    private let viewCountLabel = UILabel().then {
        $0.setLabelUI("12,345", font: .pretendard_medium, size: 12, color: .gray3)
    }
    
    // 프리뷰 이미지 뷰
    private let previewImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    // 매거진 소개 라벨
    private let descriptionLabel = UILabel().then {
        $0.setLabelUI("매거진 내용 소개", font: .pretendard, size: 14, color: .gray3)
        $0.numberOfLines = 0
        $0.lineBreakMode = .byCharWrapping
        $0.setLineSpacing(lineSpacing: 8)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAddView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    private func setAddView() {
        [titleLabel, dateLabel, viewCountStackView, previewImageView, descriptionLabel].forEach { addSubview($0) }
        
        // 스택 뷰
        [viewCountImageView, viewCountLabel].forEach { viewCountStackView.addArrangedSubview($0) }
    }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(17)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(17)
        }
        
        viewCountStackView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(52)
            make.leading.trailing.equalToSuperview().inset(17)
        }
        
        previewImageView.snp.makeConstraints { make in
            make.top.equalTo(viewCountStackView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.width)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(previewImageView.snp.bottom).offset(44)
            make.leading.trailing.equalToSuperview().inset(15)
            make.bottom.equalToSuperview()
        }
    }
    
    func configureCell(_ magazineInfo: MagazineInfo) {
        titleLabel.text = magazineInfo.title
        dateLabel.text = magazineInfo.releasedDate
        viewCountLabel.text = String(magazineInfo.viewCount)
        previewImageView.kf.setImage(with: URL(string: magazineInfo.previewImageURL))
        descriptionLabel.text = magazineInfo.description
    }
}
