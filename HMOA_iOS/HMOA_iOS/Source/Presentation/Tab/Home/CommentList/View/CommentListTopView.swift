//
//  CommentListTopView.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/02/26.
//

import UIKit
import SnapKit
import Then

class CommentListTopView: UICollectionReusableView {
    
    // MARK: - identifier
    static let identifier = "CommentListTopView"
    
    // MARK: - UI Component
    
    var commentLabel = UILabel().then {
        $0.font = .customFont(.pretendard_medium, 16)
        $0.text = "댓글"
    }
    
    var commentCountLabel = UILabel().then {
        $0.font = .customFont(.pretendard_light, 12)
        $0.text = "+565"
    }
    
    var likeSortButton = UIButton().then {
        $0.titleLabel!.font = .customFont(.pretendard_light, 12)
        $0.setTitleColor(.black, for: .selected)
        $0.setTitleColor(.customColor(.gray3), for: .normal)
        $0.setTitle("좋아요순", for: .normal)
    }
    
    var recentSortButton = UIButton().then {
        $0.titleLabel!.font = .customFont(.pretendard_light, 12)
        $0.setTitleColor(.black, for: .selected)
        $0.setTitleColor(.customColor(.gray3), for: .normal)
        $0.setTitle("최신순", for: .normal)
    }
    
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - functions
extension CommentListTopView {
    
    func configureUI() {
        
        [   commentLabel,
            commentCountLabel,
            likeSortButton,
            recentSortButton
        ]   .forEach { addSubview($0) }
        
        commentLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        
        commentCountLabel.snp.makeConstraints {
            $0.leading.equalTo(commentLabel.snp.trailing).offset(4)
            $0.centerY.equalToSuperview()
            
        }
        
        recentSortButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            
        }
        
        likeSortButton.snp.makeConstraints {
            $0.trailing.equalTo(recentSortButton.snp.leading).offset(-8)
            $0.centerY.equalToSuperview()
            
        }
    }
}
