//
//  HBTIQuantitySelectView.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 8/17/24.
//

import UIKit
import SnapKit
import Then

final class HBTIQuantitySelectTopView: UIView {
    
    // MARK: - UI Components
    
    private let categoryTitleLabel = UILabel().then {
        $0.text = HBTIQuantitySelectionData().titleLabelText
        $0.textColor = .black
        $0.font = UIFont.customFont(.pretendard_bold, 20)
        $0.textAlignment = .left
        $0.numberOfLines = 0
    }
    
    private let categoryDescriptionLabel = UILabel().then {
        $0.text = HBTIQuantitySelectionData().descriptionLabelText
        $0.textColor = .black
        $0.font = UIFont.customFont(.pretendard, 12)
    }
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
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
        [
         categoryTitleLabel,
         categoryDescriptionLabel
        ].forEach(self.addSubview)
    }
    
    // MARK: Set Constraints
    
    private func setConstraints() {
        categoryTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(127)
            $0.leading.equalToSuperview().offset(16)
        }
        
        categoryDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(categoryTitleLabel.snp.top).offset(63)
            $0.leading.equalTo(categoryTitleLabel.snp.leading).offset(109)
        }
    }
}
