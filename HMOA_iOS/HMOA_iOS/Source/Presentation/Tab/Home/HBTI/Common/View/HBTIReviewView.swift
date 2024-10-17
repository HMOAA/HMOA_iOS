//
//  HBTIReviewView.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 10/17/24.
//

import UIKit
import SnapKit
import Then

final class HBTIReviewView: UIView {

    // MARK: - UI Components
    
    private let profileImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 100
    }
    
    private let nicknameLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard, size: 12, color: .gray1)
    }
    
    private let dateLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_medium, size: 10, color: .gray3)
    }
    
    private let heartButton = UIButton().then {
        let normalImage = UIImage(named: "like")
        
        $0.setImage(normalImage, for: .normal)
        $0.setImage(normalImage?.withTintColor(.customColor(.red)), for: .selected)
    }
    
    private let likeCountLabel = UILabel().then {
        $0.setLabelUI("888", font: .pretendard, size: 14, color: .black)
    }
    
    private let contentLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard, size: 12, color: .white)
        $0.setTextWithLineHeight(text: "평소에 선호하는 향이 있었는데 그 향의 이름을 몰랐는데 향료 배송받고 시향해보니  통카 빈? 이더라구요 제가 좋아했던 향수들은 다 통카 빈이 들어가있네요 ㅎ 저 같은 분들한테 추천해요", lineHeight: 17)
        $0.textAlignment = .justified
        $0.numberOfLines = 0
    }
    
    private let imageStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 12
    }
    
    private let productCategoryLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard, size: 12, color: .white)
        $0.setTextWithLineHeight(text: "시향카드", lineHeight: 17)
    }
    
    private let optionButton = UIButton().then {
        let image = UIImage(named: "verticalOption")
        $0.setImage(image, for: .normal)
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setAddView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set UI
    private func setUI() {
        layer.cornerRadius = 5
        backgroundColor = .customColor(.gray5)
    }
    
    private func setAddView() {
        [
            profileImageView,
            nicknameLabel,
            dateLabel,
            heartButton,
            likeCountLabel,
            optionButton,
            contentLabel,
            imageStackView,
            productCategoryLabel
        ].forEach { addSubview($0) }
    }
    
    private func setConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(20)
            make.height.width.equalTo(28)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(6)
            make.centerY.equalTo(profileImageView.snp.centerY)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(nicknameLabel.snp.trailing).offset(8)
            make.centerY.equalTo(nicknameLabel.snp.centerY)
        }
        
        heartButton.snp.makeConstraints { make in
            make.trailing.equalTo(likeCountLabel.snp.leading).offset(4)
            make.centerY.equalTo(optionButton.snp.centerY)
            make.height.width.equalTo(16)
        }
        
        likeCountLabel.snp.makeConstraints { make in
            make.trailing.equalTo(optionButton.snp.leading).offset(12)
            make.bottom.equalTo(heartButton.snp.bottom)
        }
        
        optionButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(25)
            make.trailing.equalToSuperview().inset(20)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        imageStackView.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).inset(20)
            make.leading.equalToSuperview().inset(20)
            make.height.lessThanOrEqualTo(80)
            make.bottom.equalToSuperview().inset(46)
        }
        
        productCategoryLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(10)
        }
    }
    
    func configureView() {
        
    }
}
