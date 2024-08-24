//
//  HBTINotesResultView.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 8/20/24.
//

import UIKit
import SnapKit
import Then

final class HBTINotesResultCell: UITableViewCell, ReuseIdentifying {
    
    // MARK: - UI Components
    
    private let containerView = UIView().then {
        $0.backgroundColor = .customColor(.gray1)
        $0.layer.cornerRadius = 5
    }
    
    private let noteImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
    }
    
    private let titleLabel = UILabel().then {
        $0.font = .customFont(.pretendard_bold, 16)
        $0.textColor = .black
    }
    
    private let subtitleLabel = UILabel().then {
        $0.font = .customFont(.pretendard, 12)
        $0.textColor = .black
    }
    
    private let priceLabel = UILabel().then {
        $0.font = .customFont(.pretendard, 14)
        $0.textColor = .black
        $0.textAlignment = .right
    }
    
    private let descriptionLabel = UILabel().then {
        $0.font = .customFont(.pretendard, 12)
        $0.textColor = .black
        $0.numberOfLines = 3
    }
    
    // MARK: - Properties
    
    // MARK: - LifeCycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUI()
        setAddView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
         descriptionLabel
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
            $0.top.equalTo(noteImageView)
            $0.leading.equalTo(noteImageView.snp.trailing).offset(22)
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.equalTo(titleLabel)
        }
        
        priceLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(14)
            $0.trailing.equalToSuperview().inset(14)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(8)
            $0.leading.equalTo(noteImageView.snp.trailing).offset(19)
            $0.trailing.bottom.equalToSuperview().inset(40)
        }
    }
    
    // MARK: - Configuration
    func configure(with model: HBTINotesResultModel) {
        noteImageView.image = UIImage(named: model.image)
        titleLabel.text = model.title
        subtitleLabel.text = model.subtitle
        priceLabel.text = "\(model.price)원"
        descriptionLabel.text = model.description
    }
}
