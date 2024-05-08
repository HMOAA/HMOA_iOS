//
//  HPediaCommunityCell.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/04/05.
//

import UIKit

import ReactorKit

class HPediaCommunityCell: UICollectionViewCell{
    
    static let identifier = "HPediaCommunityCell"
    
    //MARK: - UI Components
    
    private let categoryLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_medium, size: 14, color: .gray2)
    }
    
    private let titleLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard, size: 16, color: .black)
    }
    
    private let likeButton = UIButton().then {
        $0.makeHeartButton()
    }
    
    private let commentButton = UIButton().then {
        $0.makeCommentButton()
    }
    
    // MARK: - Properties
    
    var isListCell: Bool = false {
        didSet {
            if !isListCell {
                layer.borderWidth = 1
                layer.borderColor = UIColor.customColor(.gray2).cgColor
                layer.cornerRadius = 3
            } else {
                layer.addBorder([.bottom], color: .customColor(.gray2), width: 1)
            }
        }
    }
    
    //MARK: - Init
    override init(frame: CGRect) {
        super .init(frame: frame)
        setUpUI()
        setAddView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - SetUp
    private func setUpUI() {
        backgroundColor = .white
    }
    
    private func setAddView() {
        [
            categoryLabel,
            titleLabel,
            likeButton,
            commentButton
        ]   .forEach { addSubview($0) }
    }
    
    private func setConstraints() {
        
        categoryLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview().inset(16)
            make.top.equalTo(categoryLabel.snp.bottom).offset(8)
        }
        
        commentButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(12)
            make.top.equalToSuperview().inset(9)
        }
        
        likeButton.snp.makeConstraints { make in
            make.trailing.equalTo(commentButton.snp.leading).offset(-8)
            make.top.equalToSuperview().inset(9)
        }
    }
    
    func configure(_ data: CategoryList) {
        categoryLabel.text = data.category
        titleLabel.text = data.title
        likeButton.configuration?.attributedTitle = AttributedString().setButtonAttirbuteString(text: "\(data.heartCount)", size: 12, font: .pretendard_light)
        likeButton.isSelected = data.liked
        if let commentCount = data.commentCount {
            commentButton.configuration?.attributedTitle = AttributedString().setButtonAttirbuteString(text: "\(commentCount)", size: 12, font: .pretendard_light)
        }
    }
}
