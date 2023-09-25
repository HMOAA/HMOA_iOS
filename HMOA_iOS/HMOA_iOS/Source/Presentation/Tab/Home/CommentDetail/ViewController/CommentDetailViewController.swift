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
        $0.layer.masksToBounds = true
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
        $0.textColor = .customColor(.gray3)
        $0.font = .customFont(.pretendard, 12)
    }
    
    lazy var commentLikeButton = UIButton().then {
        
        var buttonConfig = UIButton.Configuration.plain()

        buttonConfig.contentInsets = NSDirectionalEdgeInsets(top: 4.6, leading: 6, bottom: 4.6, trailing: 8)
        buttonConfig.imagePadding = 4
        buttonConfig.baseBackgroundColor = .customColor(.gray1)
        
        
        let config = UIImage.SymbolConfiguration(pointSize: 12, weight: .regular, scale: .default)
        let normalImage = UIImage(named: "heart", in: .none, with: config)
        let selectedImage = UIImage(named: "heart_fill", in: .none, with: config)
        
        $0.configuration = buttonConfig
        $0.setImage(normalImage, for: .normal)
        $0.setImage(selectedImage, for: .selected)
        $0.tintColor = .black
        $0.layer.cornerRadius = 10
        $0.backgroundColor = .customColor(.gray1)
    }
    
    lazy var changeButton = UIButton().then {
        $0.isHidden = true
        $0.titleLabel?.font = .customFont(.pretendard, 16)
        $0.setTitle("수정", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.tintColor = .black
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackItemNaviBar("댓글")
        configureUI()
        configureNavigationBar()
    }
}

extension CommentDetailViewController {
        
    // MARK: - Bind
    func bind(reactor: CommentDetailReactor) {
        
        // MARK: - Action
        
        // 댓글 좋아요 버튼 클릭
        commentLikeButton.rx.tap
            .map { Reactor.Action.didTapLikeButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 수정하기 버튼 클릭
        changeButton.rx.tap
            .map { Reactor.Action.didTapChangeButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: - State
        
        // 수정 버튼 보여주기
        reactor.state
            .map { $0.comment.writed }
            .filter { $0 }
            .map { !$0 }
            .bind(to: changeButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        // 이미지 바인딩
        reactor.state
            .map { $0.comment.profileImg }
            .map { URL(string: $0) }
            .bind(with: self) { owner, url in
                owner.userImageView.kf.setImage(with: url)
            }
            .disposed(by: disposeBag)
        
        // 날짜 바인딩
        reactor.state
            .map { $0.comment.createAt }
            .bind(to: dateLabel.rx.text)
            .disposed(by: disposeBag)
        
        // 댓글 내용
        reactor.state
            .map { $0.content }
            .bind(to: contentLabel.rx.text)
            .disposed(by: disposeBag)

        // 유저 이름
        reactor.state
            .map { $0.comment.nickname}
            .bind(to: userNameLabel.rx.text)
            .disposed(by: disposeBag)

        // 좋아요 개수
        reactor.state
            .map { $0.comment.heartCount }
            .map { String($0) }
            .bind(with: self, onNext: { owner, title in
                owner.commentLikeButton.configuration?.attributedTitle = AttributedString().setButtonAttirbuteString(text: title, size: 12, font: .pretendard_light)
            })
            .disposed(by: disposeBag)
        
        // 좋아요 여부
        reactor.state
            .map { $0.isLiked }
            .distinctUntilChanged()
            .bind(to: commentLikeButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        // 수정 버튼 클릭 상태
        reactor.state
            .map { $0.isTapChangeButton }
            .distinctUntilChanged()
            .filter { $0 }
            .bind(with: self) { owner, _ in
                owner.presentCommentWirteViewControllerForWriter(
                    (owner.reactor?.currentState.comment.id)!,
                    (owner.reactor?.currentState.comment.content)!,
                    reactor: reactor
                )
            }
            .disposed(by: disposeBag)
       
    }
        
    func configureUI() {
        
        view.backgroundColor = .white
        
        [   userImageView,
            userNameLabel,
            contentLabel,
            dateLabel,
            commentLikeButton
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
        }
        
        commentLikeButton.snp.makeConstraints {
            $0.centerY.equalTo(userImageView)
            $0.trailing.equalToSuperview().inset(32)
            $0.height.equalTo(20)
        }

    }
    
    func configureNavigationBar() {
        let changeButtonItem = UIBarButtonItem(customView: changeButton)
        
        self.navigationItem.rightBarButtonItem = changeButtonItem
    }
}
