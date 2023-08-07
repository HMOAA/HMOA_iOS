//
//  EvaluationHeaderView.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/08/02.
//

import UIKit

import Then
import SnapKit

class EvaluationHeaderView: UICollectionReusableView {
    
    static let identifier = "EvaluationHeaderView"
    
    let evaluationLabel = UILabel().then {
        $0.setLabelUI("이 제품에 대해 평가해주세요",
                      font: .pretendard_medium,
                      size: 20,
                      color: .black)
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubview(evaluationLabel)
        
        evaluationLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.trailing.top.equalToSuperview()
        }
    }
}
