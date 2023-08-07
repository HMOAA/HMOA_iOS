//
//  CommentCell.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/02/05.
//

import UIKit
import SnapKit
import Then
import ReactorKit
import RxSwift
import RxCocoa

class CommentCell: UICollectionViewCell, View {
    
    // MARK: - identifier
    typealias Reactor = CommentCellReactor
    var disposeBag = DisposeBag()
    
    static let identifier = "CommentCell"
    
    // MARK: - Properties
    lazy var subView = UIView().then {
        $0.layer.borderColor = UIColor.customColor(.labelGrayColor).cgColor
        $0.layer.borderWidth = 1
    }
    
    lazy var userImageView = UIImageView().then {
        $0.layer.borderColor = UIColor.white.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 27 / 2
        $0.layer.backgroundColor = UIColor.customColor(.tabbarColor).cgColor
    }
    
    lazy var userNameLabel = UILabel().then {
        $0.font = UIFont.customFont(.pretendard, 14)
        $0.text = "TEST"
    }
    
    lazy var contentLabel = UILabel().then {
        $0.numberOfLines = 2
        $0.font = UIFont.customFont(.pretendard, 14)
    }
    
//    lazy var likeView = LikeView()
    lazy var commentLikeButton = UIButton().then {
        $0.makeLikeButton()
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


// MARK: - Functions
extension CommentCell {
    
    func bind(reactor: CommentCellReactor) {
        userImageView.image = reactor.currentState.image
        userNameLabel.text = reactor.currentState.name
        contentLabel.text = reactor.currentState.content
        commentLikeButton.isSelected = reactor.currentState.isLike
        // MARK: - Action

        // 댓글 좋아요 버튼 클릭
        commentLikeButton.rx.tap
            .map { Reactor.Action.didTapLikeButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: - State
        
        // 좋아요 상태 반응
        reactor.state
            .map { $0.isLike }
            .distinctUntilChanged()
            .bind(to: commentLikeButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        // 좋아요 개수 반응
        reactor.state
            .map { $0.likeCount }
            .distinctUntilChanged()
            .filter { $0 != 0 }
            .map { String($0)}
            .bind(onNext: {
                self.commentLikeButton.configuration?.attributedTitle = self.setLikeButtonText($0)
            })
            .disposed(by: disposeBag)
    }
    
    func updateCell(_ item: Comment) {
        userImageView.image = item.image
        userNameLabel.text = item.name
        contentLabel.text = item.content
        commentLikeButton.isSelected = item.isLike
        commentLikeButton.configuration?.attributedTitle = self.setLikeButtonText(String(item.likeCount))
    }
    
    func configureUI() {
        
        addSubview(subView)
        
        
        [   userImageView,
            userNameLabel,
            contentLabel,
            commentLikeButton  ] .forEach { subView.addSubview($0) }

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
        
        commentLikeButton.snp.makeConstraints {
            $0.centerY.equalTo(userImageView)
            $0.trailing.equalToSuperview().inset(16)
//            $0.width.equalTo(60)
            $0.height.equalTo(20)
        }
    }
    
    func setLikeButtonText(_ text: String) -> AttributedString {
        var attri = AttributedString.init(text)
        attri.font = .customFont(.pretendard_light, 12)
        
        return attri
    }
}
