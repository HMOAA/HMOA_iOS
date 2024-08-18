//
//  HBTISurveyOptionCell.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 7/12/24.
//

import UIKit

import Then
import SnapKit
import RxSwift

final class HBTISurveyQuestionCell: UICollectionViewCell {
    
    static let identifier = "HBTISurveyQuestionCell"
    
    var disposeBag = DisposeBag()
    
    // MARK: - UI Components
    
    private let questionMarkLabel = UILabel().then {
        $0.setLabelUI("Q.", font: .pretendard, size: 20, color: .black)
    }
    
    private let questionLabel = UILabel().then {
        $0.setLabelUI("질문질문질문질문?", font: .pretendard, size: 20, color: .black)
        $0.numberOfLines = 0
        $0.lineBreakStrategy = .hangulWordPriority
    }
    
    let answerStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 16
        $0.distribution = .equalSpacing
        $0.alignment = .fill
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
        [questionMarkLabel, 
         questionLabel,
         answerStackView
        ].forEach { addSubview($0) }
    }
    
    private func setConstraints() {
        questionMarkLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }
        
        questionLabel.snp.makeConstraints { make in
            make.leading.equalTo(questionMarkLabel.snp.trailing).offset(8)
            make.top.trailing.equalToSuperview()
        }
        
        answerStackView.snp.makeConstraints { make in
            make.top.equalTo(questionLabel.snp.bottom).offset(32)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    func configureCell(question: HBTIQuestion, answers: [HBTIAnswer]) {
        questionLabel.text = question.content
        
        answerStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        answers.forEach {
            let button = HBTISurveyAnswerButton()
            button.answerLabel.text = $0.content
            button.isSelected = false
            button.snp.makeConstraints { make in
                make.height.equalTo(50)
            }
            answerStackView.addArrangedSubview(button)
        }
    }
}
