//
//  MagazineLatestCell.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 3/7/24.
//

import UIKit
import SnapKit
import Then

class MagazineLatestCell: UICollectionViewCell {
    
    static let identifier = "MagazineLatestCell"
    
    // MARK: - UI Components
    
    // 표지 이미지 뷰
    private let coverImageView = UIImageView()
    
    // 제목 스택 뷰
    private let titleStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 0
        $0.alignment = .leading
    }
    
    // 슬로건 라벨
    private let sloganLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard, size: 12, color: .white)
    }
    
    // 향수 이름 라벨
    private let perfumeNameLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_bold, size: 12, color: .white)
    }
    
    // 초기화
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
        [coverImageView, titleStackView].forEach { addSubview($0) }
        
        [sloganLabel, perfumeNameLabel].forEach { titleStackView.addArrangedSubview($0) }
    }
    
    private func setConstraints() {
        coverImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.width.equalTo(132)
            make.height.equalTo(coverImageView.snp.width).multipliedBy(184.0 / 132.0)
        }
        
        titleStackView.snp.makeConstraints { make in
            make.top.equalTo(coverImageView.snp.bottom).offset(12)
            make.leading.bottom.trailing.equalToSuperview()
        }
    }
    
    func configureCell(_ magazine: Magazine) {
        coverImageView.backgroundColor = .random
        sloganLabel.text = magazine.slogan
        perfumeNameLabel.text = magazine.perfumeName
    }
}
