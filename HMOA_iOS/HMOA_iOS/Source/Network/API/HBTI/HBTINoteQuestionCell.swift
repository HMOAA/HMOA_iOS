//
//  HBTINoteQuestionCell.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 9/5/24.
//

import UIKit

import Then
import SnapKit

class HBTINoteQuestionCell: UICollectionViewCell {
    
    static let identifier = "HBTINoteQuestionCell"
    
    // MARK: - UI Components
    
    private let selectLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_bold, size: 20, color: .black)
        $0.setTextWithLineHeight(text: "선택안내", lineHeight: 27)
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
        [
            selectLabel
        ].forEach { addSubview($0) }
    }
    
    private func setConstraints() {
    }
    
    func configureCell(question: HBTINoteQuestion) {
        selectLabel.text = question.content
    }
    
}
