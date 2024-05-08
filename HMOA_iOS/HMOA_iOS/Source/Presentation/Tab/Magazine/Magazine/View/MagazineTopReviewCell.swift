//
//  MagazineTopReviewCell.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 2/26/24.
//

import UIKit
import Then
import SnapKit
import Kingfisher

class MagazineTopReviewCell: UICollectionViewCell {
    
    static let identifier = "MagazineTopReviewCell"
    
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
    
    private let profileImageView = UIImageView().then {
        $0.clipsToBounds = true
    }
    
    private let nicknameLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard, size: 12, color: .gray3)
    }
    
    private let contentLabel = UILabel().then {
        $0.setLabelUI("내용", font: .pretendard, size: 13, color: .black)
        $0.numberOfLines = 5
        $0.setTextWithLineHeight(text: $0.text, lineHeight: 19)
    }
    
    private let profileImageWidth: CGFloat = 20
    
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
        profileImageView.layer.cornerRadius = profileImageWidth / 2
        layer.borderWidth = 1
        layer.borderColor = UIColor.customColor(.gray2).cgColor
    }
    
    private func setAddView() {
        [profileImageView, nicknameLabel].forEach { 
            userStackView.addArrangedSubview($0)
        }
        
        [titleLabel, userStackView, contentLabel].forEach {
            reviewContentStackView.addSubview($0)
        }
        
        addSubview(reviewContentStackView)
    }
    
    private func setConstraint() {
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
            make.height.width.equalTo(profileImageWidth)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(6)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(userStackView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.height.lessThanOrEqualTo(100)
        }
    }
    
    func configureCell(_ topReview: TopReview) {
        titleLabel.text = topReview.title
        profileImageView.kf.setImage(with: URL(string: topReview.userImageURL))
        nicknameLabel.text = topReview.userName
        contentLabel.text = topReview.content
    }
}
