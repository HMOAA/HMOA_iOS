//
//  MyPageTopView.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/01/21.
//

import UIKit
import SnapKit
import Then

class MyPageTopView: UIView {
    
    // MARK: - Properties
    
    lazy var profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "jomalon")
        $0.layer.borderWidth = 0.5
        $0.layer.cornerRadius = 0.5 * 80
    }
    
    let nickNameLabel = UILabel().then {
        $0.text = "닉네임"
        $0.font = .systemFont(ofSize: 15, weight: .bold)
    }
    
    let editButton = UIButton().then {
        $0.setImage(UIImage(named: "edit"), for: .normal)
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

// MARK: Functions

extension MyPageTopView {
    
    func configureUI() {
        [profileImageView, nickNameLabel, editButton] .forEach { addSubview($0) }
        
        profileImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(63)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(80)
        }
        
        nickNameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        editButton.snp.makeConstraints {
            $0.centerY.equalTo(nickNameLabel)
            $0.leading.equalTo(nickNameLabel.snp.trailing).offset(9)
        }
    }
}
