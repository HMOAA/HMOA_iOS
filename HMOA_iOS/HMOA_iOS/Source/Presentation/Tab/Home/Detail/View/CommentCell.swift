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
        $0.layer.borderColor = UIColor.customColor(.searchBarColor).cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 27 / 2
        $0.image = UIImage(named: "jomalon")
    }
    
    lazy var userNameLabel = UILabel().then {
        $0.font = UIFont.customFont(.pretendard, 14)
        $0.text = "TEST"
    }
    
    lazy var contentLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.font = UIFont.customFont(.pretendard, 12)
    }
    
    lazy var likeButton = UIButton().then {
        let config = UIImage.SymbolConfiguration(pointSize: 12, weight: .regular, scale: .default)
        let image = UIImage(systemName: "heart", withConfiguration: config)
        
        $0.layer.cornerRadius = 10
        $0.tintColor = .black
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel!.font = UIFont.customFont(.pretendard, 12)
        $0.setTitle("80", for: .normal)
        $0.setImage(image, for: .normal)
        $0.backgroundColor = UIColor.customColor(.searchBarColor)

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
extension CommentCell {
    
    func configureUI() {
        
        addSubview(subView)
        
        [   userImageView,
            userNameLabel,
            contentLabel,
            likeButton  ] .forEach { subView.addSubview($0) }

        subView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        userImageView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(5)
            $0.width.height.equalTo(27)
        }
        
        userNameLabel.snp.makeConstraints {
            $0.centerY.equalTo(userImageView)
            $0.leading.equalTo(userImageView.snp.trailing).offset(8)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(userImageView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(5)
            $0.bottom.equalTo(likeButton.snp.top)
        }
        
        likeButton.snp.makeConstraints {
            $0.trailing.bottom.equalToSuperview().inset(10)
            $0.width.equalTo(50)
            $0.height.equalTo(20)
        }
    }
}
