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
        [titleLabel, dateLabel, viewCountStackView].forEach { addSubview($0) }
        
        // 스택 뷰
        [viewCountImageView, viewCountLabel].forEach { viewCountStackView.addArrangedSubview($0) }
    }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
        }
        
        viewCountStackView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(52)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func configureCell(_ magazineInfo: MagazineInfo) {
        titleLabel.text = magazineInfo.title
        dateLabel.text = magazineInfo.releasedDate
        viewCountLabel.text = String(magazineInfo.viewCount)
    }
}
