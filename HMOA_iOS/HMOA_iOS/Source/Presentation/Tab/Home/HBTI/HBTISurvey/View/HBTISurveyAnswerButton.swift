//
//  HBTISurveyAnswerCell.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 7/13/24.
//

import UIKit

import Then
import SnapKit

final class HBTISurveyAnswerButton: UIButton {
    
    // MARK: - UI Components
    
    private let checkBoxImageView = UIImageView()
    
    let answerLabel = UILabel().then {
        $0.setLabelUI("답변", font: .pretendard, size: 14, color: .black)
    }
    
    override var isSelected: Bool {
        didSet {
            layer.backgroundColor = isSelected
                ? #colorLiteral(red: 0.3913987577, green: 0.3913987279, blue: 0.3913987577, alpha: 1)
                : #colorLiteral(red: 0.9626654983, green: 0.9626654983, blue: 0.9626654983, alpha: 1)
            checkBoxImageView.image = isSelected
                ? UIImage(named: "checkBoxSelected")
                : UIImage(named: "checkBoxNotSelected")
            answerLabel.textColor = isSelected 
                ? .white
                : .black
        }
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
    
    // MARK: - Function
    
    private func setUI() {
        isSelected = false
        layer.cornerRadius = 5
        layer.masksToBounds = true
    }
    
    private func setAddView() {
        [checkBoxImageView, answerLabel].forEach { addSubview($0) }
    }
    
    private func setConstraints() {
        checkBoxImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(19)
            make.centerY.equalToSuperview()
            make.width.equalTo(18)
        }
        
        answerLabel.snp.makeConstraints { make in
            make.leading.equalTo(checkBoxImageView.snp.trailing).offset(15)
            make.trailing.equalToSuperview().inset(19)
            make.centerY.equalToSuperview()
        }
    }
}
