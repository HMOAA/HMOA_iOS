//
//  MagazineMainCell.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 2/26/24.
//

import UIKit
import Then
import SnapKit
import Kingfisher

class MagazineMainCell: UICollectionViewCell {
    
    static let identifier = "MagazineMainCell"
    
    // MARK: UI Components
    private let coverImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    private let label = UILabel().then {
        $0.setLabelUI("Hello", font: .pretendard, size: 24, color: .blue)
    }
    
    private let labelStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 12
        $0.distribution = .equalSpacing
        $0.alignment = .fill
    }
    
    private let titleLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_bold, size: 24, color: .white)
        $0.numberOfLines = 0
        $0.lineBreakMode = .byCharWrapping
    }
    
    private let descriptionLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard, size: 14, color: .white)
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setGradientLayer()
        setAddView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setGradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = layer.bounds
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        
        let colors: [CGColor] = [
            UIColor.clear.cgColor,
            UIColor.black.withAlphaComponent(0.8).cgColor
        ]
        gradientLayer.colors = colors
        
        coverImageView.layer.addSublayer(gradientLayer)
    }
    
    private func setAddView() {
        [titleLabel, descriptionLabel].forEach{ labelStackView.addArrangedSubview($0)}
        
        coverImageView.addSubview(labelStackView)
        
        addSubview(coverImageView)
        addSubview(label)
    }
    
    private func setConstraints() {
        coverImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(coverImageView.snp.width).multipliedBy(376.0 / 328.0)
        }
        
        labelStackView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(32)
            make.leading.trailing.equalToSuperview().inset(24)
        }
    }
    
    func configureCell(_ magazine: Magazine) {
        coverImageView.kf.setImage(with: URL(string: magazine.previewImageURL))
        titleLabel.text = magazine.title
        descriptionLabel.text = magazine.description
    }
}
