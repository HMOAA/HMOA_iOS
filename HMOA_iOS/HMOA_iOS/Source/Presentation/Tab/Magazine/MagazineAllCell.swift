//
//  MagazineAllCell.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 2/26/24.
//

import UIKit
import SnapKit
import Then

class MagazineAllCell: UICollectionViewCell {
    
    static let identifier = "MagazineAllCell"
    
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 12
        $0.distribution = .equalSpacing
        $0.alignment = .fill
    }
    
    private let titleStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 0
        $0.distribution = .equalSpacing
        $0.alignment = .fill
    }
    
    private let coverImageView = UIImageView()
    
    private let sloganLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard, size: 20, color: .black)
    }
    
    private let perfumeNameLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_bold, size: 20, color: .black)
    }
    
    private let longDescriptionLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard, size: 14, color: .black)
        $0.numberOfLines = 0
        $0.lineBreakMode = .byCharWrapping
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
        [sloganLabel, perfumeNameLabel].forEach {
            titleStackView.addArrangedSubview($0)
        }
        
        [coverImageView, titleStackView, longDescriptionLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        
        addSubview(stackView)
    }
    
    private func setConstraints() {
        coverImageView.snp.makeConstraints { make in
            make.top.trailing.leading.equalToSuperview()
            make.height.equalTo(coverImageView.snp.width)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
    }
    
    func configureCell(_ magazine: Magazine) {
        coverImageView.backgroundColor = magazine.coverImage
        sloganLabel.text = magazine.slogan
        perfumeNameLabel.text = magazine.perfumeName
        longDescriptionLabel.text = magazine.longDescription
    }
}
