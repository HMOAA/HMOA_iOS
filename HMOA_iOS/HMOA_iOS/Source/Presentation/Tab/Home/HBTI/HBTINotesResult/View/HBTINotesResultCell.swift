//
//  HBTINotesResultView.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 8/20/24.
//

import UIKit
import SnapKit
import Then
import Kingfisher

final class HBTINotesResultCell: UICollectionViewCell, ReuseIdentifying {
    
    // MARK: - UI Components
    
    private let containerView = UIView().then {
        $0.backgroundColor = .customColor(.gray1)
        $0.layer.cornerRadius = 5
    }
    
    private let noteImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 33
    }
    
    private let titleLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_bold, size: 16, color: .black)
    }
    
    private let subtitleLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard, size: 12, color: .black)
    }
    
    private let priceLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard, size: 14, color: .black)
        $0.textAlignment = .right
    }
    
    private let descriptionStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 2
        $0.alignment = .leading
        $0.distribution = .equalSpacing
    }
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setAddView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // MARK: Set UI
    
    private func setUI() {
        
    }
    
    // MARK: Add Views
    
    private func setAddView() {
        contentView.addSubview(containerView)
                
        [
         noteImageView,
         titleLabel,
         subtitleLabel,
         priceLabel,
         descriptionStackView
        ].forEach(containerView.addSubview)
    }
    
    // MARK: Set Constraints
    
    private func setConstraints() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        noteImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(16)
            $0.width.height.equalTo(66)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalTo(noteImageView.snp.trailing).offset(22)
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.equalTo(titleLabel)
        }
        
        priceLabel.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview().inset(14)
        }
        
        descriptionStackView.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(8)
            $0.leading.equalTo(titleLabel.snp.leading).offset(3)
            $0.trailing.equalToSuperview().inset(40)
            $0.bottom.equalToSuperview().inset(16)
        }
    }
    
    // MARK: - Configuration
    func configureCell(cartItem: HBTICategory) {
        noteImageView.kf.setImage(with: URL(string: cartItem.imageURL))
        titleLabel.text = cartItem.name
        subtitleLabel.text = "(\(cartItem.noteCount)가지 향료)"
        priceLabel.text = "\(cartItem.price)원"
        
        descriptionStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        cartItem.noteList.forEach { note in
            let descriptionLabel = UILabel().then {
                $0.setLabelUI("· \(note.name): \(note.content)", font: .pretendard, size: 12, color: .black)
                $0.setTextWithLineHeight(text: "· \(note.name): \(note.content)", lineHeight: 20)
                $0.numberOfLines = 0
            }
            descriptionStackView.addArrangedSubview(descriptionLabel)
        }
    }
}
