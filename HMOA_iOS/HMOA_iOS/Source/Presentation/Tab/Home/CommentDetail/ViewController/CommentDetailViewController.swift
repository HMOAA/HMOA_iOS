//
//  CommentDetailViewController.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/02/21.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import ReactorKit

class CommentDetailViewController: UIViewController, View {
    typealias Reactor = CommentDetailReactor
    
    var disposeBag = DisposeBag()
    
    // MARK: - UI Component
    
    lazy var userImageView = UIImageView().then {
        $0.layer.borderColor = UIColor.white.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 27 / 2
        $0.layer.backgroundColor = UIColor.customColor(.tabbarColor).cgColor
    }
    
    lazy var userNameLabel = UILabel().then {
        $0.font = .customFont(.pretendard, 14)
    }
    
    lazy var contentLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.font = .customFont(.pretendard, 14)
    }
    
    lazy var dateLabel = UILabel().then {
        $0.font = .customFont(.pretendard, 12)
    }
    
    lazy var likeView = LikeView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackItemNaviBar("댓글")
        configureUI()
    }
}

extension CommentDetailViewController {
        
    // MARK: - Bind
    func bind(reactor: CommentDetailReactor) {
        
        // MARK: - Action
        
        // 댓글 좋아요 버튼 클릭
        likeView.likeButton.rx.tap
            .map { Reactor.Action.didTapLikeButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: - State
        
        // 유저 이미지
        reactor.state
            .map { $0.comment.image }
            .bind(to: userImageView.rx.image)
            .disposed(by: disposeBag)
        
        // 댓글 내용
        reactor.state
            .map { $0.comment.content }
            .bind(to: contentLabel.rx.text)
            .disposed(by: disposeBag)
        
        // 좋아요 상태
        reactor.state
            .map { $0.comment.isLike }
            .bind(to: likeView.likeButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        // 유저 이름
        reactor.state
            .map { $0.comment.name }
            .bind(to: userNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        // 좋아요 개수
        reactor.state
            .map { $0.comment.likeCount }
            .map { String($0) }
            .bind(to: likeView.likeCountLabel.rx.text)
            .disposed(by: disposeBag)
    }
        
    func configureUI() {
        
        view.backgroundColor = .white
        
        [   userImageView,
            userNameLabel,
            contentLabel,
            dateLabel,
            likeView
        ]   .forEach { view.addSubview($0) }
        
        userImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(14)
            $0.leading.equalToSuperview().inset(32)
            $0.width.height.equalTo(28)
        }
        
        userNameLabel.snp.makeConstraints {
            $0.centerY.equalTo(userImageView)
            $0.leading.equalTo(userImageView.snp.trailing).offset(8)
        }
        
        dateLabel.snp.makeConstraints {
            $0.centerY.equalTo(userImageView)
            $0.leading.equalTo(userNameLabel.snp.trailing).offset(8)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(userImageView.snp.bottom).offset(9)
            $0.leading.trailing.equalToSuperview().inset(32)
//            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        likeView.snp.makeConstraints {
            $0.centerY.equalTo(userImageView)
            $0.trailing.equalToSuperview().inset(16)
            $0.width.equalTo(60)
            $0.height.equalTo(20)
        }

    }
}
