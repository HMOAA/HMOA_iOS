//
//  CommentCell.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/02/05.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class CommentCell: UICollectionViewCell {
    
    // MARK: - identifier
    
    static let identifier = "CommentCell"
    
    // MARK: - Properties
    lazy var subView = UIView().then {
        $0.layer.cornerRadius = 10
        $0.isHidden = true
        $0.layer.borderColor = UIColor.customColor(.gray2).cgColor
        $0.layer.borderWidth = 1
    }
    
    lazy var userImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 28 / 2
    }
    
    lazy var userNameLabel = UILabel().then {
        $0.font = UIFont.customFont(.pretendard, 14)
    }
    
    lazy var contentLabel = UILabel().then {
        $0.numberOfLines = 2
        $0.font = UIFont.customFont(.pretendard, 14)
    }
    
//    lazy var likeView = LikeView()
    lazy var commentLikeButton = UIButton().then {
        $0.makeLikeButton()
    }
    
    lazy var noCommentLabel = UILabel().then {
        $0.isHidden = true
        $0.setLabelUI("해당 제품의 의견을 남겨주세요",
                      font: .pretendard_light,
                      size: 14,
                      color: .gray3)
    }
    
    lazy var communityNoCommentLabel = UILabel().then {
        $0.isHidden = true
        $0.setLabelUI("아직 작성한 댓글이 없습니다",
                      font: .pretendard_medium,
                      size: 20,
                      color: .black)
    }
    
    lazy var optionButton = UIButton().then {
        $0.setImage(UIImage(named: "verticalOption"), for: .normal)
    }
    
    
    var disposeBag = DisposeBag()
    
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
extension CommentCell {
    
    func updateCell(_ item: Comment?) {
        if let item = item {
            commentLikeButton.isSelected = item.liked
            userImageView.kf.setImage(with: URL(string: item.profileImg))
            userNameLabel.text = item.nickname
            contentLabel.text = item.content
            commentLikeButton.configuration?.attributedTitle = self.setLikeButtonText(String(item.heartCount))
            subView.isHidden = false
            noCommentLabel.isHidden = true
            
        } else { noCommentLabel.isHidden = false }
    }
    
    func updateCommunityComment(_ item: CommunityComment?) {
        if let item = item {
            userImageView.kf.setImage(with: URL(string: item.profileImg))
            userNameLabel.text = item.author
            contentLabel.text = item.content
            commentLikeButton.isHidden = true
            subView.isHidden = false
            communityNoCommentLabel.isHidden = true
            
        } else { communityNoCommentLabel.isHidden = false }
    }
    
    func updateForMyLogComment() {
        optionButton.isHidden = true
        commentLikeButton.snp.remakeConstraints { make in
            make.top.equalToSuperview().inset(14)
            make.trailing.equalToSuperview().inset(14)
            make.height.equalTo(20)
        }
    }
    
    func configureUI() {
        
        addSubview(subView)
        addSubview(noCommentLabel)
        addSubview(communityNoCommentLabel)
        
        [   userImageView,
            userNameLabel,
            contentLabel,
            commentLikeButton,
            optionButton
        ] .forEach { subView.addSubview($0) }

        subView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        userImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(9)
            $0.leading.equalToSuperview().inset(16)
            $0.width.height.equalTo(28)
        }
        
        userNameLabel.snp.makeConstraints {
            $0.centerY.equalTo(userImageView)
            $0.leading.equalTo(userImageView.snp.trailing).offset(8)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(userImageView.snp.bottom).offset(9)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(9)
        }
    
        noCommentLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        communityNoCommentLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        optionButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(15.2)
            make.trailing.equalToSuperview().inset(13)
        }
        
        commentLikeButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(14)
            $0.trailing.equalTo(optionButton.snp.leading).offset(-14.2)
            $0.height.equalTo(20)
        }
        
    }
    
    func setLikeButtonText(_ text: String) -> AttributedString {
        var attri = AttributedString.init(text)
        attri.font = .customFont(.pretendard_light, 12)
        
        return attri
    }
}
