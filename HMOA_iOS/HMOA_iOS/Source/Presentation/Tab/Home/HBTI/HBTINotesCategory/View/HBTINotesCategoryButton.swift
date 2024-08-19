//
//  HBTINotesCategoryButton.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 8/19/24.
//

import Foundation

final class HBTINotesCategoryButton: UIButton {
    
    // MARK: - UI Components
    
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 34
    }
    
    private let titleLabel = UILabel().then {
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
         imageView,
         titleLabel,
         descriptionLabel
        ].forEach(addSubview)
    }
    
    // MARK: Set Constraints
    
    private func setConstraints() {
        imageView.snp.makeConstraints {
            $0.top.centerX.equalToSuperview()
            $0.size.equalTo(68)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(12)
            $0.centerX.equalTo(imageView)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.width.equalTo(60)
        }
    }
    
    // MARK: - Configuration
    
    func configure() {
        
    }
}
