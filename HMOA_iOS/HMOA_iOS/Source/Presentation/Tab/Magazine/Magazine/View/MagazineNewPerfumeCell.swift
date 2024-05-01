//
//  MagazineNewPerfumeCell.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 2/26/24.
//

import UIKit
import Then
import SnapKit
import Kingfisher

class MagazineNewPerfumeCell: UICollectionViewCell {
    
    static let identifier = "MagazineNewPerfumeCell"
    
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private let imageBackgroundView = UIView().then {
        $0.backgroundColor = #colorLiteral(red: 0.850980401, green: 0.850980401, blue: 0.850980401, alpha: 1)
    }
    
    private let brandLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard, size: 10, color: .gray3 )
    }
    
    private let perfumeNameLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard, size: 12, color: .black)
    }
    
    private let dateLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard, size: 10, color: .gray3)
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
        imageBackgroundView.addSubview(imageView)
        [imageBackgroundView, brandLabel, perfumeNameLabel, dateLabel].forEach { addSubview($0) }
    }
    
    private func setConstraints() {
        imageBackgroundView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.width.height.equalTo(155)
        }
        
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(111.57)
        }
        
        brandLabel.snp.makeConstraints { make in
            make.top.equalTo(imageBackgroundView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview()
        }
        
        perfumeNameLabel.snp.makeConstraints { make in
            make.top.equalTo(brandLabel.snp.bottom).offset(6)
            make.leading.trailing.equalToSuperview()
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(perfumeNameLabel.snp.bottom).offset(8)
            make.left.trailing.equalToSuperview()
        }
    }
    
    func configureCell(_ newPerfume: NewPerfume) {
        imageView.kf.setImage(with: URL(string: newPerfume.perfumeImageURL))
        brandLabel.text = newPerfume.brand
        perfumeNameLabel.text = newPerfume.name
        dateLabel.text = newPerfume.releaseDate
    }
    
}
