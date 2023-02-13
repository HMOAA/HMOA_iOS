//
//  LikeView.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/02/11.
//

import UIKit
import SnapKit
import Then

class LikeView: UIView {
    
    // MARK: - Properties
    
    let likeButton = UIButton().then {

        let config = UIImage.SymbolConfiguration(pointSize: 12, weight: .regular, scale: .default)
        let normalImage = UIImage(systemName: "heart", withConfiguration: config)
        let selectedImage = UIImage(systemName: "heart_fill", withConfiguration: config)
        
        $0.setImage(normalImage, for: .normal)
        $0.setImage(selectedImage, for: .selected)
        $0.tintColor = .black
    }
    
    let likeCountLabel = UILabel().then {
        $0.font = UIFont.customFont(.pretendard_light, 12)
        $0.text = "120"
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

extension LikeView {
    
    func configureUI() {
        [   likeButton,
            likeCountLabel  ] .forEach { addSubview($0) }
        
        layer.cornerRadius = 10
        backgroundColor = UIColor.customColor(.gray1)
        

        likeButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(6)
        }
        
        likeCountLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(likeButton.snp.trailing).offset(4)
        }
    }
}
