//
//  DetailBottomView.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/02/12.
//

import UIKit
import SnapKit
import Then

class DetailBottomView: UIView {
    
    // MARK: Properties

    lazy var likeButton = UIButton().then {
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular, scale: .default)
        let normalImage = UIImage(named: "bottomHeart", in: .none, with: config)
        let selectedImage = UIImage(named: "bottomHeart", in: .none, with: config)?.withTintColor(.red)

        $0.setImage(normalImage, for: .normal)
        $0.setImage(selectedImage, for: .selected)
    }

    lazy var wirteButton: UIButton = {
       
        var config = UIButton.Configuration.plain()
        let attri = AttributedString.init("댓글작성")
        
        config.attributedTitle?.font = .customFont(.pretendard_medium, 16)
        config.titleAlignment = .trailing
        config.image = UIImage(named: "bottomComment")
        config.imagePadding = 10
        config.baseForegroundColor = .white
        config.attributedTitle = attri
        let button = UIButton(configuration: config)
        
        return button
    }()
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DetailBottomView {
    
    func configureUI() {
        backgroundColor = .black
        
        [   likeButton,
            wirteButton   ]   .forEach { addSubview($0) }
        
        likeButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(17)
            $0.leading.equalToSuperview().inset(32)
        }
        
        wirteButton.snp.makeConstraints {
            $0.top.equalTo(likeButton)
            $0.trailing.equalToSuperview().inset(32)
            $0.height.equalTo(23)
        }
    }
}
