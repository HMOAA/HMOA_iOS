//
//  CommentFooterView.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/02/11.
//

import UIKit
import SnapKit
import Then

class CommentFooterView: UICollectionReusableView {
    
    // MARK: - identifier
    static let identifier = "CommentFooterView"
    
    // MARK: - Properies

    let moreButton = UIButton().then {
        $0.tintColor = UIColor.customColor(.gray4)
        $0.titleLabel?.textColor = .white
        $0.titleLabel?.font = UIFont.customFont(.pretendard_medium, 12)
        $0.setTitle("모두 보기", for: .normal)
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
extension CommentFooterView {
    func configureUI() {
        addSubview(moreButton)
        
        backgroundColor = UIColor.customColor(.gray4)
        
        moreButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
