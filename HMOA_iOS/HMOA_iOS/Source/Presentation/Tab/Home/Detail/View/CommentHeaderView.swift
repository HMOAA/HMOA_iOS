//
//  CommentHeaderView.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/02/11.
//

import UIKit
import SnapKit
import Then

class CommentHeaderView: UICollectionReusableView {

    // MARK: - identifier
    
    static let identifier = "CommentHeaderView"
    
    // MARK: - Properies
    
    let titleLabel = UILabel().then {
        $0.font = UIFont.customFont(.pretendard_medium, 16)
        $0.text = "댓글"
    }
    
    let countLabel = UILabel().then {
        $0.font = UIFont.customFont(.pretendard_light, 12)
        $0.text = "+565"
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

// MARK: - Functions
extension CommentHeaderView {
    
    func configureUI() {
        
        [   titleLabel,
            countLabel  ]   .forEach { addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
        }
        
        countLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(titleLabel.snp.trailing).offset(4)
        }
    }
}
