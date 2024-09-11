//
//  HBTINotesCategoryButton.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 8/19/24.
//

import UIKit
import SnapKit
import Then

final class HBTINotesCategoryButton: UIButton {
    
    // MARK: - UI Components
    
    private let customImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 34
    }
    
    private let customTitleLabel = UILabel().then {
        $0.font = .customFont(.pretendard_semibold, 14)
        $0.textColor = .black
        $0.textAlignment = .center
    }
    
    private let descriptionLabel = UILabel().then {
        $0.font = .customFont(.pretendard, 10)
        $0.textColor = .black
        $0.textAlignment = .center
        $0.numberOfLines = 3
    }
    
    // MARK: - Init
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setAddView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set UI
        
    private func setUI() {

    }
    
    // MARK: Add Views
    
    private func setAddView() {
        [
         customImageView,
         customTitleLabel,
         descriptionLabel
        ].forEach(addSubview)
    }
    
    // MARK: Set Constraints
    
    private func setConstraints() {
        customImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.size.equalTo(68)
        }
        
        customTitleLabel.snp.makeConstraints {
            $0.top.equalTo(customImageView.snp.bottom).offset(12)
            $0.centerX.equalTo(customImageView)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(customTitleLabel.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
        }
    }
    
    func configureButton(with category: HBTINotesCategoryData) {
        customImageView.image = UIImage(named: category.image)?.resize(targetSize: CGSize(width: 68, height: 68))
        customTitleLabel.text = category.title
        descriptionLabel.text = category.description
    }
}
