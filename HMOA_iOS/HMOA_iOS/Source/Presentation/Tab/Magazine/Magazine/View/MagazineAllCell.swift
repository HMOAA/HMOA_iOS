//
//  MagazineAllCell.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 2/26/24.
//

import UIKit
import SnapKit
import Then
import Kingfisher

class MagazineAllCell: UICollectionViewCell {
    
    static let identifier = "MagazineAllCell"
    
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 12
        $0.distribution = .equalSpacing
        $0.alignment = .fill
    }
    
    private let coverImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    private let titleLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_bold, size: 20, color: .black)
        $0.numberOfLines = 2
        $0.lineBreakMode = .byWordWrapping
        $0.setTextWithLineHeight(text: "제목", lineHeight: 24)
    }
    
    private let longDescriptionLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard, size: 14, color: .black)
        $0.numberOfLines = 3
        $0.lineBreakMode = .byCharWrapping
        $0.setTextWithLineHeight(text: "소개", lineHeight: 22)
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
        [coverImageView, titleLabel, longDescriptionLabel].forEach {
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
            make.edges.equalToSuperview()
        }
    }
    
    func configureCell(_ magazine: Magazine) {
        coverImageView.kf.setImage(with: URL(string: magazine.previewImageURL))
        titleLabel.text = magazine.title
        longDescriptionLabel.text = magazine.description
    }
}
