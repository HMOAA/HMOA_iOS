//
//  MagazineTopReviewCell.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 2/26/24.
//

import UIKit
import Then
import SnapKit

class MagazineTopReviewCell: UICollectionViewCell {
    
    static let identifier = "MagazineTopReviewCell"
    
    private let cardView = UIView().then {
        $0.layer.borderColor = UIColor.customColor(.gray2).cgColor
        $0.layer.borderWidth = 1
    }
    
    private let reviewContentStackView = UIView()
    
    private let titleLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_bold, size: 16, color: .black)
    }
    
    private let userStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 6
        $0.distribution = .equalSpacing
        $0.alignment = .fill
    }
    
    private let profileImageView = UIImageView()
    
    private let nicknameLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard, size: 12, color: .gray3)
    }
    
    private let contentLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard, size: 14, color: .black)
        $0.numberOfLines = 0
        $0.lineBreakMode = .byCharWrapping
    }
    
    private let profileImageSize: CGFloat = 20
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setAddView()
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        profileImageView.layer.cornerRadius = profileImageSize / 2
    }
    
    private func setAddView() {
        [profileImageView, nicknameLabel].forEach { 
            userStackView.addArrangedSubview($0)
        }
        
        [titleLabel, userStackView, contentLabel].forEach {
            reviewContentStackView.addSubview($0)
        }
        
        cardView.addSubview(reviewContentStackView)
        
        addSubview(cardView)
    }
    
    private func setConstraint() {
        cardView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        reviewContentStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24)
            make.leading.trailing.bottom.equalToSuperview().inset(20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        
        userStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview()
        }
        
        profileImageView.snp.makeConstraints { make in
            make.height.width.equalTo(profileImageSize)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(6)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(userStackView.snp.bottom).offset(16)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    func configureCell(_ topReview: TopReview) {
        titleLabel.text = topReview.title
        profileImageView.backgroundColor = topReview.userImage
        nicknameLabel.text = topReview.userName
        contentLabel.text = topReview.content
    }
}
