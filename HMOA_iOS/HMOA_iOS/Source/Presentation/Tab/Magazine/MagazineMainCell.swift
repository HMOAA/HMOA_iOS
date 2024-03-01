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
    private let coverImageView = UIImageView()
    
    private let label = UILabel().then {
        $0.setLabelUI("Hello", font: .pretendard, size: 24, color: .blue)
    }
    
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
        $0.lineBreakMode = .byWordWrapping
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
        [sloganLabel, perfumeNameLabel].forEach { titleStackView.addArrangedSubview($0) }
        
        [titleStackView, descriptionLabel].forEach{ labelStackView.addArrangedSubview($0)}
        
        coverImageView.addSubview(labelStackView)
        
        addSubview(coverImageView)
        addSubview(label)
    }
    
    private func setConstraints() {
        coverImageView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        labelStackView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(32)
            make.leading.trailing.equalToSuperview().inset(24)
        }
    }
    
    func configureCell(_ magazine: Magazine) {
        coverImageView.backgroundColor = magazine.coverImage
        sloganLabel.text = magazine.slogan
        perfumeNameLabel.text = magazine.perfumeName
        descriptionLabel.text = magazine.description
    }
}
