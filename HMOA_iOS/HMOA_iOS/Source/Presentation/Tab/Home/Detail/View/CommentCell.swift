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
    private lazy var subView = UIView().then {
        $0.isHidden = true
    }
    
    private lazy var userImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 28 / 2
    }
    
    private lazy var userNameLabel = UILabel().then {
        $0.font = UIFont.customFont(.pretendard, 14)
    }
    
    private lazy var contentLabel = UILabel().then {
        $0.numberOfLines = 2
        $0.font = UIFont.customFont(.pretendard, 14)
    }
    
    lazy var commentLikeButton = UIButton().then {
        $0.makeLikeButton()
    }
    
    private lazy var userMarkImageView = UIImageView().then {
        $0.image = UIImage(named: "postMark")
    }
    
    private lazy var dateLabel = UILabel().then {
        $0.textColor = .customColor(.gray3)
        $0.font = .customFont(.pretendard, 12)
    }
    
    private lazy var noCommentLabel = UILabel().then {
        $0.isHidden = true
        $0.setLabelUI("해당 제품의 의견을 남겨주세요",
                      font: .pretendard_light,
                      size: 14,
                      color: .gray3)
    }
    
    private lazy var communityNoCommentLabel = UILabel().then {
        $0.isHidden = true
        $0.setLabelUI("아직 작성한 댓글이 없습니다",
                      font: .pretendard_medium,
                      size: 20,
                      color: .black)
    }
    
    lazy var optionButton = UIButton().then {
        $0.setImage(UIImage(named: "commentOption"), for: .normal)
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        subView.layer.addBorder([.bottom], color: UIColor.customColor(.gray2), width: 1)
    }
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
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
            dateLabel.text = item.createAt
            userMarkImageView.isHidden = !item.writed
            
        } else {
            noCommentLabel.isHidden = false
            subView.isHidden = true
        }
    }
    
    func updateCommunityComment(_ item: CommunityComment?) {
        if let item = item {
            userImageView.kf.setImage(with: URL(string: item.profileImg))
            userNameLabel.text = item.author
            contentLabel.text = item.content
            subView.isHidden = false
            communityNoCommentLabel.isHidden = true
            dateLabel.text = item.time
            userMarkImageView.isHidden = !item.writed
            commentLikeButton.isSelected = item.liked
            commentLikeButton.configuration?.attributedTitle = self.setLikeButtonText(String(item.heartCount))
        } else {
            communityNoCommentLabel.isHidden = false
            subView.isHidden = true
        }
    }
    
    func updateForMyLogComment(_ item: MyLogComment) {
        optionButton.isHidden = true
        commentLikeButton.isSelected = item.liked
        userImageView.kf.setImage(with: URL(string: item.profileImg))
        userNameLabel.text = item.nickname
        contentLabel.text = item.content
        commentLikeButton.configuration?.attributedTitle = self.setLikeButtonText(String(item.heartCount))
        subView.isHidden = false
        noCommentLabel.isHidden = true
        commentLikeButton.isHidden = false
        dateLabel.text = item.createAt
        userMarkImageView.isHidden = !item.writed
        
        commentLikeButton.snp.remakeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalTo(commentLikeButton)
            make.height.equalTo(20)
        }
    }
    
    private func configureUI() {
        
        addSubview(subView)
        addSubview(noCommentLabel)
        addSubview(communityNoCommentLabel)
        
        [   userImageView,
            userNameLabel,
            contentLabel,
            commentLikeButton,
            userMarkImageView,
            dateLabel,
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
        
        userMarkImageView.snp.makeConstraints {
            $0.leading.equalTo(userNameLabel.snp.trailing).offset(2)
            $0.centerY.equalTo(userImageView)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(userImageView.snp.bottom).offset(9)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(9)
        }
    
        noCommentLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(20)
        }
        
        communityNoCommentLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        optionButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalTo(commentLikeButton)
            make.height.equalTo(20)
        }
        
        commentLikeButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.trailing.equalTo(optionButton.snp.leading).offset(-8)
            $0.height.equalTo(20)
        }
        
    }
    override func updateConstraints() {
        super.updateConstraints()
        
        if userMarkImageView.isHidden {
            dateLabel.snp.remakeConstraints {
                $0.bottom.equalTo(userNameLabel.snp.bottom)
                $0.leading.equalTo(userNameLabel.snp.trailing).offset(7)
            }
        } else {
            dateLabel.snp.remakeConstraints {
                $0.bottom.equalTo(userNameLabel.snp.bottom)
                $0.leading.equalTo(userMarkImageView.snp.trailing).offset(2)
            }
        }
    }
    
    func setLikeButtonText(_ text: String) -> AttributedString {
        var attri = AttributedString.init(text)
        attri.font = .customFont(.pretendard_light, 12)
        
        return attri
    }
}
