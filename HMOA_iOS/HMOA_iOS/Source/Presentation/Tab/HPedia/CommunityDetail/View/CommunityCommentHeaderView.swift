//
//  CommunityCommentHeaderView.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/09/11.
//

import UIKit

class CommunityCommentHeaderView: UICollectionReusableView {
    // MARK: - identifier
    static let identifier = "CommunityCommentHeaderView"
    
    // MARK: - UI Component
    var commentLabel = UILabel().then {
        $0.font = .customFont(.pretendard_medium, 16)
        $0.text = "답변"
    }
    
    var commentCountLabel = UILabel().then {
        $0.font = .customFont(.pretendard_light, 12)
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
            commentCountLabel
        ]   .forEach { addSubview($0) }
        
        commentLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        
        commentCountLabel.snp.makeConstraints {
            $0.leading.equalTo(commentLabel.snp.trailing).offset(4)
            $0.centerY.equalToSuperview()
            
        }
    }
}


