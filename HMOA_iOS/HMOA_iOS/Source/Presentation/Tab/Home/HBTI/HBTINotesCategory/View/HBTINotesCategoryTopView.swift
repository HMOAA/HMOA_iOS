//
//  HBTINotesCategoryTopView.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 8/19/24.
//

import UIKit
import SnapKit
import Then

final class HBTINotesCategoryTopView: UIView {
    
    // MARK: - UI Components
    
    private let noteStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 12
        $0.alignment = .fill
        $0.distribution = .fill
    }
    
    private let categoryTitleLabel = UILabel().then {
        $0.setTextWithLineHeight(text: HBTINotesCategoryData().titleLabelText, lineHeight: 27)
        $0.setLabelUI(HBTINotesCategoryData().titleLabelText, font: .pretendard_bold, size: 20, color: .black)
        $0.textAlignment = .left
        $0.numberOfLines = 0
    }
    
    private let categoryDescriptionLabel = UILabel().then {
        $0.setLabelUI(HBTINotesCategoryData().descriptionLabelText, font: .pretendard_medium, size: 14, color: .gray5)
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
         noteStackView
        ].forEach(self.addSubview)
        
        [
         categoryTitleLabel,
         categoryDescriptionLabel
        ].forEach(noteStackView.addArrangedSubview)
    }
    
    // MARK: Set Constraints
    
    private func setConstraints() {
        noteStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
