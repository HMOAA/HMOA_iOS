//
//  QnACommentHeaderView.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/09/11.
//

import UIKit

class QnACommentHeaderView: UICollectionReusableView {
    // MARK: - identifier
    static let identifier = "QnACommentHeaderView"
    
    // MARK: - UI Component
    
    var commentLabel = UILabel().then {
        $0.font = .customFont(.pretendard_medium, 16)
        $0.text = "답변"
    }
    
    var commentCountLabel = UILabel().then {
        $0.font = .customFont(.pretendard_light, 12)
        $0.text = "+565"
    }
    
    var addCommentButton = UIButton().then {
        $0.setTitleColor(.black, for: .normal)
        $0.setTitle("답글 달기", for: .normal)
        $0.titleLabel?.font = .customFont(.pretendard_light, 12)
        $0.layer.cornerRadius = 10
        $0.backgroundColor = UIColor.customColor(.gray1)
    }
    
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        
        [   commentLabel,
            commentCountLabel,
            addCommentButton
        ]   .forEach { addSubview($0) }
        
        commentLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        
        commentCountLabel.snp.makeConstraints {
            $0.leading.equalTo(commentLabel.snp.trailing).offset(4)
            $0.centerY.equalToSuperview()
            
        }
        
        addCommentButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(56)
            $0.height.equalTo(20)
        }
    }
}


