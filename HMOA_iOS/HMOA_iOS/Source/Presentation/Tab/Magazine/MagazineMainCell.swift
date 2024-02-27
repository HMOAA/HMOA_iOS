//
//  MagazineMainCell.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 2/26/24.
//

import UIKit
import Then
import SnapKit

class MagazineMainCell: UICollectionViewCell {
    
    static let identifier = "MagazineMainCell"
    
    // MARK: UI Components
    private let coverImage = UIImageView()
    
    private let titleStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 0
        $0.distribution = .equalSpacing
        $0.alignment = .fill
    }
    
    private let labelStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 12
        $0.distribution = .equalSpacing
        $0.alignment = .fill
    }
    
    private let sloganLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard, size: 24, color: .white)
    }
    
    private let perfumeNameLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_bold, size: 24, color: .white)
    }
    
    private let descriptionLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard, size: 14, color: .white)
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
    
    fileprivate func setAddView() {
        addSubview(coverImage)
        
        titleStackView.addArrangedSubview(sloganLabel)
        titleStackView.addArrangedSubview(perfumeNameLabel)
        
        labelStackView.addArrangedSubview(titleStackView)
        labelStackView.addArrangedSubview(descriptionLabel)
        
        coverImage.addSubview(labelStackView)
    }
    
    fileprivate func setConstraints() {
        coverImage.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(coverImage.snp.width).multipliedBy(1.15)
        }
        
        labelStackView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(32)
            make.leading.trailing.equalToSuperview().inset(24)
        }
    }
    
    func configureCell(_ magazine: Magazine) {
        coverImage.backgroundColor = magazine.coverImage
        sloganLabel.text = magazine.slogan
        perfumeNameLabel.text = magazine.perfumeName
        descriptionLabel.text = magazine.description
    }
}
