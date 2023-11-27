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
        
        LoginManager.shared.isLogin
            .map { Reactor.Action.viewDidLoad($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 댓글 좋아요 버튼 클릭
        commentLikeButton.rx.tap
            .map { Reactor.Action.didTapLikeButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: - State
        
        // comment 바인딩
        reactor.state
            .map { $0.comment }
            .compactMap { $0 }
            .bind(with: self) { owner, comment in
                owner.userImageView.kf.setImage(with: URL(string: comment.profileImg))
                owner.dateLabel.text = comment.createAt
                owner.contentLabel.text = comment.content
                owner.userNameLabel.text = comment.nickname
                owner.commentLikeButton.configuration?.attributedTitle = AttributedString().setButtonAttirbuteString(text: "\(comment.heartCount)", size: 12, font: .pretendard_light)
            }
            .disposed(by: disposeBag)
        
        // communityComment 바인딩
        reactor.state
            .map { $0.communityCommet }
            .compactMap { $0 }
            .bind(with: self) { owner, comment in
                owner.userImageView.kf.setImage(with: URL(string: comment.profileImg))
                owner.dateLabel.text = comment.time
                owner.contentLabel.text = comment.content
                owner.userNameLabel.text = comment.author
                owner.commentLikeButton.isHidden = true
            }
            .disposed(by: disposeBag)
        
        // 좋아요 여부
        reactor.state
            .map { $0.isLiked }
            .distinctUntilChanged()
            .bind(to: commentLikeButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        // 로그인 안되있을 시 present
        reactor.state
            .map { $0.isTapWhenNotLogin }
            .distinctUntilChanged()
            .filter { $0 }
            .bind(with: self, onNext: { owner, _ in
                owner.presentAlertVC(
                    title: "로그인 후 이용가능한 서비스입니다",
                    content: "입력하신 내용을 다시 확인해주세요",
                    buttonTitle: "로그인 하러가기 ")
            })
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
