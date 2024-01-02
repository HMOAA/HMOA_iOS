//
//  MyPageTopView.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/01/21.
//

import UIKit
import SnapKit
import Then
import Kingfisher

class MyPageUserCell: UITableViewCell {
    
    // MARK: - identifier
    static let identifier = "MyPageUserCell"
    
    // MARK: - Properties

    private lazy var profileImage = UIImageView().then {
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 22
    }
    
    private lazy var nickNameLabel = UILabel().then {
        $0.font = .customFont(.pretendard_medium, 20)
    }
    
    private lazy var loginTypeLabel = UILabel().then {
        $0.font = .customFont(.pretendard_light, 12)
    }
    
    lazy var editButton = UIButton().then {
        $0.tintColor = .customColor(.gray2)
        $0.setImage(UIImage(named: "edit"), for: .normal)
    }
    
    // MARK: - init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Functions

extension MyPageUserCell {
    
    // MARK: - Configure
    func configureUI() {
      
        [   profileImage,
            nickNameLabel,
            loginTypeLabel,
            editButton
        ]   .forEach { addSubview($0) }
        
        profileImage.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().inset(16)
            $0.width.height.equalTo(44)
        }
        
        nickNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalTo(profileImage.snp.trailing).offset(12)
        }
        
        loginTypeLabel.snp.makeConstraints {
            $0.bottom.equalTo(profileImage.snp.bottom)
            $0.leading.equalTo(nickNameLabel)
        }
        
        editButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(34)
            make.trailing.equalToSuperview().inset(16)
            make.width.height.equalTo(20)
        }
    }
    
    func updateCell(_ member: Member, _ image: UIImage?) {
        
        nickNameLabel.text = member.nickname
        loginTypeLabel.text = member.provider
        profileImage.image = image
    }
}
