//
//  QnAPostCell.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/09/11.
//

import UIKit

import Then
import SnapKit

class QnAPostCell: UICollectionViewCell {
    
    static let identifier = "QnAPostCell"
    
    //MARK: - UIComponents
    let QLabel = UILabel().then {
        $0.setLabelUI("Q", font: .pretendard_bold, size: 26, color: .black)
    }
    
    let profileImageView = UIImageView().then {
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 14
    }
    
    let nicknameLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard, size: 14, color: .black)
    }
    
    let dayLabel = UILabel().then {
        $0.setLabelUI("일 전", font: .pretendard, size: 12, color: .gray3)
    }
    
    let titleLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.setLabelUI("", font: .pretendard_medium, size: 20, color: .black)
    }
    
    let contentLabel = UILabel().then {
        $0.lineBreakMode = .byCharWrapping
        $0.numberOfLines = 0
        $0.setLabelUI("", font: .pretendard_medium, size: 16, color: .black)
    }
    
    lazy var optionButton = UIButton().then {
        $0.isHidden = true
        $0.setImage(UIImage(named: "verticalOption"), for: .normal)
    }
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpUI()
        setAddView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - SetUp
    private func setUpUI() {
        layer.cornerRadius = 10
        layer.borderColor = UIColor.customColor(.gray2).cgColor
        layer.borderWidth = 1
    }
    
    private func setAddView() {
        [
            QLabel,
            profileImageView,
            nicknameLabel,
            dayLabel,
            titleLabel,
            contentLabel,
            optionButton
        ]   .forEach { addSubview($0) }
    }
    
    private func setConstraints() {
        
        optionButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(16.32)
        }
        
        QLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(20)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.leading.equalTo(QLabel.snp.trailing).offset(8)
            make.top.equalToSuperview().inset(22)
            make.width.height.equalTo(28)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(29)
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
        }
        
        dayLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(31)
            make.leading.equalTo(nicknameLabel.snp.trailing).offset(2)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(QLabel.snp.bottom).offset(10)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.bottom.lessThanOrEqualToSuperview().inset(48)
        }
    }
}

extension QnAPostCell {
    func updateCell(_ item: CommunityDetail) {
        if item.writed { optionButton.isHidden = false }
        profileImageView.kf.setImage(with: URL(string: item.profileImgUrl))
        nicknameLabel.text = item.author
        dayLabel.text = item.time
        titleLabel.text = item.title
        contentLabel.text = item.content
    }
}
