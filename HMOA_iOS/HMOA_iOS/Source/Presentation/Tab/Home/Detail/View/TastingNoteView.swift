//
//  TastingNoteView.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/02/11.
//

import UIKit
import SnapKit
import Then

class TastingNoteView: UIView {
    
    // MARK: - Properties
    
    lazy var leftImageView = UIImageView().then {
        $0.layer.backgroundColor = UIColor.customColor(.tabbarColor).cgColor
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.white.cgColor
        $0.layer.cornerRadius = 30
    }
    
    lazy var centerImageView = UIImageView().then {
        $0.layer.backgroundColor = UIColor.customColor(.tabbarColor).cgColor
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.white.cgColor
        $0.layer.cornerRadius = 30
    }
    
    lazy var rightImageView = UIImageView().then {
        $0.layer.backgroundColor = UIColor.customColor(.tabbarColor).cgColor
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.white.cgColor
        $0.layer.cornerRadius = 30
    }
    
    lazy var nameLabel = UILabel().then {
        $0.textColor = .white
        $0.font = UIFont.customFont(.pretendard, 12)
    }

    lazy var lineView = UIView().then {
        $0.backgroundColor = UIColor.customColor(.gray2)
    }
    
    lazy var posLabel = UILabel().then {
        $0.font = UIFont.customFont(.pretendard, 16)
        $0.textColor = UIColor.customColor(.gray3)
    }
    
    init(name: String, pos: String) {
        super.init(frame: .zero)
        self.nameLabel.text = name
        self.posLabel.text = pos
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TastingNoteView {
    
    func configureUI() {
        [   leftImageView,
            centerImageView,
            rightImageView,
            lineView,
            posLabel    ]   .forEach { addSubview($0) }
        
        centerImageView.addSubview(nameLabel)
        
        leftImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.width.height.equalTo(60)
        }
        
        centerImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(leftImageView.snp.trailing)
            $0.width.height.equalTo(60)
        }
        
        rightImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(centerImageView.snp.trailing)
            $0.width.height.equalTo(60)
        }
        
        nameLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        
        lineView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(rightImageView.snp.trailing).offset(6)
            $0.height.equalTo(1)
        }
        
        posLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(lineView.snp.trailing).offset(6)
            $0.trailing.equalToSuperview().inset(32)
        }
    }
}
