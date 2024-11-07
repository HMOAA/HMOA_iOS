//
//  HBTINotesCategoryTopView.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 8/19/24.
//

import UIKit
import SnapKit
import Then

final class HBTINotesCategoryHeaderView: UICollectionReusableView, ReuseIdentifying {
    
    // MARK: - UI Components
    
    private lazy var headerViewStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 12
        $0.alignment = .fill
        $0.distribution = .fill
    }
    
    private lazy var headerViewTitleLabel = UILabel().then {
        $0.setTextWithLineHeight(text: "", lineHeight: 27)
        $0.setLabelUI("", font: .pretendard_bold, size: 20, color: .black)
        $0.textAlignment = .left
        $0.numberOfLines = 0
    }
    
    private lazy var headerViewDescriptionLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_medium, size: 14, color: .gray5)
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
         headerViewStackView
        ].forEach(self.addSubview)
        
        [
         headerViewTitleLabel,
         headerViewDescriptionLabel
        ].forEach(headerViewStackView.addArrangedSubview)
    }
    
    // MARK: Set Constraints
    
    private func setConstraints() {
        headerViewStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: Other Functions
    
    func configureHeaderViewLabel(bestNote: String) {
        let headerViewLabelText = HBTICategoryLabelTexts(bestNote: bestNote)
        
        headerViewTitleLabel.text = headerViewLabelText.titleLabelText
        headerViewDescriptionLabel.text = headerViewLabelText.descriptionLabelText
    }
}
