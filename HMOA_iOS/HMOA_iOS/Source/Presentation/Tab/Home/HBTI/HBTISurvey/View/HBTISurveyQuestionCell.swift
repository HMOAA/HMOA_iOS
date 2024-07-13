//
//  HBTISurveyOptionCell.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 7/12/24.
//

import UIKit

import Then
import SnapKit

class HBTISurveyQuestionCell: UICollectionViewCell {
    
    static let identifier = "HBTISurveyQuestionCell"
    
    // MARK: - UI Components
    
    private let questionMarkLabel = UILabel().then {
        $0.setLabelUI("Q.", font: .pretendard, size: 20, color: .black)
    }
    
    private let questionLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard, size: 20, color: .black)
        $0.numberOfLines = 0
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
    
    // MARK: - Function
    
    private func setAddView() {
        [questionMarkLabel, questionLabel].forEach { addSubview($0) }
    }
    
    private func setConstraints() {
        questionMarkLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }
        
        questionLabel.snp.makeConstraints { make in
            make.leading.equalTo(questionMarkLabel.snp.trailing).offset(8)
            make.verticalEdges.trailing.equalToSuperview()
        }
    }
    
}
