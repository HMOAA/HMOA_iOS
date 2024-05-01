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
    
    private lazy var userImageView = UIImageView().then {
        $0.layer.masksToBounds = true
        $0.layer.borderColor = UIColor.white.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 27 / 2
        $0.layer.backgroundColor = UIColor.customColor(.tabbarColor).cgColor
    }
    
    private lazy var userNameLabel = UILabel().then {
        $0.font = .customFont(.pretendard, 14)
    }
    
    private lazy var contentLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.font = .customFont(.pretendard, 14)
    }
    
    private lazy var userMarkImageView = UIImageView().then {
        $0.image = UIImage(named: "postMark")
    }
    
    private lazy var dateLabel = UILabel().then {
        $0.textColor = .customColor(.gray3)
        $0.font = .customFont(.pretendard, 12)
    }
    
    private lazy var commentLikeButton = UIButton().then {
        $0.makeLikeButton()
    }
    
    private let optionButton = UIButton().then {
        $0.setImage(UIImage(named: "commentOption"), for: .normal)
    }
    
    private lazy var optionView = OptionView().then {
        $0.reactor = OptionReactor()
        $0.parentVC = self
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackItemNaviBar("댓글")
        configureUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if userMarkImageView.isHidden {
            dateLabel.snp.makeConstraints {
                $0.bottom.equalTo(userNameLabel.snp.bottom)
                $0.leading.equalTo(userNameLabel.snp.trailing).offset(7)
            }
        } else {
            dateLabel.snp.makeConstraints {
                $0.bottom.equalTo(userNameLabel.snp.bottom)
                $0.leading.equalTo(userMarkImageView.snp.trailing).offset(2)
            }
        }
    }
}

extension CommentDetailViewController {
        
    // MARK: - Bind
    func bind(reactor: CommentDetailReactor) {
        
        // MARK: - Action
        
        LoginManager.shared.isLogin
            .map { Reactor.Action.viewDidLoad($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 댓글 좋아요 버튼 클릭
        commentLikeButton.rx.tap
            .map { Reactor.Action.didTapLikeButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 옵션 버튼 터치
        optionButton.rx.tap
            .map { Reactor.Action.didTapOptionButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 향수 댓글 옵션 버튼
        reactor.state
            .map { $0.optionCommentData}
            .compactMap { $0 }
            .map { OptionReactor.Action.didTapOptionButton(.Comment($0)) }
            .bind(to: optionView.reactor!.action)
            .disposed(by: disposeBag)
        
        // 옵션 삭제 버튼 터치
        optionView.reactor?.state
            .map { $0.isTapDelete }
            .filter { $0 }
            .map { _ in Reactor.Action.didDeleteComment }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: - State
        
        // comment 바인딩
        reactor.state
            .map { $0.comment }
            .compactMap { $0 }
            .asDriver(onErrorRecover: { _ in return .empty() })
            .drive(with: self, onNext: { owner, comment in
                owner.userImageView.kf.setImage(with: URL(string: comment.profileImg))
                owner.dateLabel.text = comment.createAt
                owner.contentLabel.text = comment.content
                owner.userNameLabel.text = comment.nickname
                owner.commentLikeButton.configuration?.attributedTitle = AttributedString().setButtonAttirbuteString(text: "\(comment.heartCount)", size: 12, font: .pretendard_light)
                
                owner.userMarkImageView.isHidden = !comment.writed
            })
            .disposed(by: disposeBag)
        
        // communityComment 바인딩
        reactor.state
            .map { $0.communityCommet }
            .compactMap { $0 }
            .asDriver(onErrorRecover: { _ in return .empty() })
            .drive(with: self, onNext: { owner, comment in
                owner.userImageView.kf.setImage(with: URL(string: comment.profileImg))
                owner.dateLabel.text = comment.time
                owner.contentLabel.text = comment.content
                owner.userNameLabel.text = comment.author
                owner.userMarkImageView.isHidden = !comment.writed
                owner.commentLikeButton.configuration?.attributedTitle = AttributedString().setButtonAttirbuteString(text: "\(comment.heartCount)", size: 12, font: .pretendard_light)
            })
            .disposed(by: disposeBag)
        
        // 좋아요 여부
        reactor.state
            .map { $0.isLiked }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(to: commentLikeButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        // 로그인 안되있을 시 present
        reactor.state
            .map { $0.isTapWhenNotLogin }
            .distinctUntilChanged()
            .filter { $0 }
            .asDriver(onErrorRecover: { _ in return .empty() })
            .drive(with: self, onNext: { owner, _ in
                owner.presentAlertVC(
                    title: "로그인 후 이용가능한 서비스입니다",
                    content: "입력하신 내용을 다시 확인해주세요",
                    buttonTitle: "로그인 하러가기 ")
            })
            .disposed(by: disposeBag)
        
        // 댓글 삭제시 popVC
        reactor.state
            .map { $0.isDeleteComment }
            .filter { $0 }
            .asDriver(onErrorRecover: { _ in return .empty() })
            .drive(with: self, onNext: { owner, _ in
                owner.popViewController()
            })
            .disposed(by: disposeBag)
    }
        
    private func configureUI() {
        
        view.backgroundColor = .white
        
        [   userImageView,
            userNameLabel,
            contentLabel,
            userMarkImageView,
            dateLabel,
            commentLikeButton,
            optionButton,
            optionView
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
    
        userMarkImageView.snp.makeConstraints {
            $0.leading.equalTo(userNameLabel.snp.trailing).offset(2)
            $0.centerY.equalTo(userImageView)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(userImageView.snp.bottom).offset(9)
            $0.leading.trailing.equalToSuperview().inset(32)
        }
        
        optionButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalTo(userImageView)
            $0.height.equalTo(20)
        }
        
        commentLikeButton.snp.makeConstraints {
            $0.centerY.equalTo(userImageView)
            $0.trailing.equalTo(optionButton.snp.leading).offset(-8)
            $0.height.equalTo(20)
        }
        
        optionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

    }
}
