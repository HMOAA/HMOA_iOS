//
//  HBTIHomeSurveyHeaderView.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 7/11/24.
//

import UIKit

import SnapKit
import Then

final class HBTIHomeSurveyHeaderView: UICollectionReusableView {
    
    static let identifier = "HBTIHomeSurveyHeaderView"
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel().then {
        $0.setLabelUI("당신의 향BTI는 무엇일까요?", font: .pretendard_bold, size: 20, color: .white)
    }
    
    private let descriptionLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard, size: 14, color: .white)
        $0.setTextWithLineHeight(text: "검사를 통해 좋아하는 향료와\n향수까지 알아보세요!", lineHeight: 17)
        $0.numberOfLines = 2
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAddView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set UI
    
    private func setAddView() {
        [titleLabel,
         descriptionLabel
        ].forEach { addSubview($0) }
    }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.horizontalEdges.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
}
