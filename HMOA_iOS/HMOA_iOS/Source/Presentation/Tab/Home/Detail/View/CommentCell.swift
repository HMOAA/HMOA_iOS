//
//  CommentCell.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/02/05.
//

import UIKit
import SnapKit
import Then

class CommentCell: UICollectionViewCell {
    
    // MARK: - identifier
    
    static let identifier = "CommentCell"
    
    // MARK: - Properties
    lazy var subView = UIView().then {
        $0.layer.borderColor = UIColor.customColor(.labelGrayColor).cgColor
        $0.layer.borderWidth = 1
    }
    
    lazy var userImageView = UIImageView().then {
        $0.layer.borderColor = UIColor.white.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 27 / 2
        $0.layer.backgroundColor = UIColor.customColor(.tabbarColor).cgColor
    }
    
    lazy var userNameLabel = UILabel().then {
        $0.font = UIFont.customFont(.pretendard, 14)
        $0.text = "TEST"
    }
    
    lazy var contentLabel = UILabel().then {
        $0.numberOfLines = 2
        $0.font = UIFont.customFont(.pretendard, 14)
    }
    
    lazy var likeView = LikeView()
    
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
extension CommentCell {
    
    func configureUI() {
        
        addSubview(subView)
        
        [   userImageView,
            userNameLabel,
            contentLabel,
            likeView  ] .forEach { subView.addSubview($0) }

        subView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        userImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(9)
            $0.leading.equalToSuperview().inset(16)
            $0.width.height.equalTo(28)
        }
        
        userNameLabel.snp.makeConstraints {
            $0.centerY.equalTo(userImageView)
            $0.leading.equalTo(userImageView.snp.trailing).offset(8)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(userImageView.snp.bottom).offset(9)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(9)
        }
        
        likeView.snp.makeConstraints {
            $0.centerY.equalTo(userImageView)
            $0.trailing.equalToSuperview().inset(16)
            $0.width.equalTo(60)
            $0.height.equalTo(20)
        }
    }
}
