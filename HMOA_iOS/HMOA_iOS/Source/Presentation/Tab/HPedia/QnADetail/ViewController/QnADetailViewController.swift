//
//  QnADetailViewController.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/09/11.
//

import UIKit

import Then
import SnapKit
import RxCocoa
import RxSwift
import ReactorKit
import Kingfisher

class QnADetailViewController: UIViewController, View {

    //MARK: - Properties
    var dataSource: UICollectionViewDiffableDataSource<QnADetailSection, QnADetailSectionItem>!
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureLayout()).then {
        
        $0.register(QnAPostHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: QnAPostHeaderView.identifier)
        $0.register(QnACommentHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: QnACommentHeaderView.identifier)
        $0.register(CommentCell.self, forCellWithReuseIdentifier: CommentCell.identifier)
        $0.register(QnAPostCell.self, forCellWithReuseIdentifier: QnAPostCell.identifier)
        
    }
    
    
    let commentWriteView = UIView().then {
        $0.layer.cornerRadius = 5
        $0.backgroundColor =  #colorLiteral(red: 0.8797428608, green: 0.8797428012, blue: 0.8797428608, alpha: 1)
    }
    
    let profileImageView = UIImageView().then {
        $0.image = UIImage(named: "initProfile")
        $0.layer.cornerRadius = 14
        $0.layer.masksToBounds = true
    }
    
    let colonLabel = UILabel().then {
        $0.setLabelUI(":", font: .pretendard, size: 14, color: .black)
    }
    
    let commentTextView = UITextView().then {
        $0.text = "댓글을 입력하세요"
        $0.font = .customFont(.pretendard, 14)
        $0.backgroundColor =  #colorLiteral(red: 0.8797428608, green: 0.8797428012, blue: 0.8797428608, alpha: 1)
    }
    
    let commentWriteButton = UIButton().then {
        $0.setImage(UIImage(named: "commentWrite"), for: .normal)
    }
    
    lazy var commentOptionView = OptionView().then {
        $0.reactor = OptionReactor(service: reactor!.service)
        $0.parentVC = self
    }
    
    lazy var postOptionView = OptionView().then {
        $0.reactor = OptionReactor(service: reactor!.service)
    }
    
    var disposeBag = DisposeBag()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        setAddView()
        setConstraints()
        setNavigationBarTitle(title: "Community", color: .white, isHidden: false)
        configureDataSource()
    }
    
    

    //MARK: - SetUp
    private func setUpUI() {
        view.backgroundColor = .white
    }
    
    private func setAddView() {
        
        [
            profileImageView,
            colonLabel,
            commentTextView,
            commentWriteButton,
        ]   .forEach { commentWriteView.addSubview($0) }
        
        [
            collectionView,
            commentWriteView,
            commentOptionView,
            postOptionView
        ]   .forEach { view.addSubview($0) }
    }
    
    private func setConstraints() {
        collectionView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(98)
        }
        
        commentWriteView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(46)
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(-10)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(11)
            make.width.height.equalTo(28)
            make.centerY.equalToSuperview()
        }
        
        colonLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(profileImageView.snp.trailing).offset(4)
        }
        
        commentTextView.snp.makeConstraints { make in
            make.leading.equalTo(colonLabel.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(36)
            make.top.bottom.equalToSuperview()
        }
        
        commentWriteButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(9)
            make.centerY.equalToSuperview()
        }
        
        commentOptionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        postOptionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func bind(reactor: QnADetailReactor) {
        
        // Action
        commentTextView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        // 빈 화면 터치 시 키보드 내리기
        collectionView.rx
            .itemSelected
            .distinctUntilChanged()
            .bind(with: self) { owner, index in
                owner.view.endEditing(true)
                owner.commentTextView.text = "댓글을 입력하세요"
            }
            .disposed(by: disposeBag)
        
        // willDisplayCell
        collectionView.rx.willDisplayCell
            .filter { $0.at.section == 1 }
            .map {
                let currentItem = $0.at.item
                if (currentItem + 1) % 6 == 0 && currentItem != 0 {
                    return currentItem / 6 + 1
                }
                return nil
            }
            .compactMap { $0 }
            .map { Reactor.Action.willDisplayCell($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // viewDidLoad
        LoginManager.shared.isLogin
            .map { Reactor.Action.viewDidLoad($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // textView 사용자가 입력 시작
        commentTextView.rx.didBeginEditing
            .map { Reactor.Action.didBeginEditing }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        //textView text 감지
        commentTextView.rx.text.orEmpty
            .distinctUntilChanged()
            .skip(1)
            .map { Reactor.Action.didChangeTextViewEditing($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 댓글 작성 버튼 터치
        commentWriteButton.rx.tap
            .map { Reactor.Action.didTapCommentWriteButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 댓글 옵션 뷰 삭제 버튼 터치
        commentOptionView.reactor?.state
            .map { $0.isTapDelete }
            .distinctUntilChanged()
            .filter { $0 }
            .map { _ in Reactor.Action.didDeleteComment }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 게시글 옵션 뷰 삭제 버튼 터치
        postOptionView.reactor?.state
            .map { $0.isTapDelete }
            .distinctUntilChanged()
            .filter { $0 }
            .map { _ in Reactor.Action.didDeletePost}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 댓글 셀 터치
        collectionView.rx.itemSelected
            .filter { $0.section == 1 }
            .map { Reactor.Action.didTapCommentCell($0.row)}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // State
        
        //colectionView binding
        reactor.state
            .map { $0.communityItems }
            .distinctUntilChanged()
            .filter { !$0.postItem.isEmpty}
            .asDriver(onErrorRecover: { _ in .empty() })
            .drive(with: self, onNext: { owner, items in
                var snapshot = NSDiffableDataSourceSnapshot<QnADetailSection, QnADetailSectionItem>()
                snapshot.appendSections([.qnaPost, .comment])
    
                items.postItem.forEach { snapshot.appendItems([.qnaPostCell($0)], toSection: .qnaPost) }
                
                snapshot.appendItems(items.commentItem.map { .commentCell($0) }, toSection: .comment)
                
                DispatchQueue.main.async {
                    owner.dataSource.apply(snapshot)
                }
            })
            .disposed(by: disposeBag)
        
        // 텍스트 뷰 터치 시 빈칸으로 만들기
        reactor.state
            .map { $0.isBeginEditing }
            .distinctUntilChanged()
            .filter { $0 }
            .bind(with: self) { owner, _ in
                owner.commentTextView.text = ""
            }.disposed(by: disposeBag)
        
        // 텍스트 뷰 높이에 따라 commentWrite뷰 높이 변경
        reactor.state
            .map { $0.content }
            .map { _ in
                let contentSize = self.commentTextView.sizeThatFits(CGSize(width: self.commentTextView.bounds.width, height: CGFloat.greatestFiniteMagnitude))
                return contentSize.height + 13
            }
            .distinctUntilChanged()
            .filter { $0 < 100}
            .bind(with: self) { owner, height in
                print(height)
                DispatchQueue.main.async {
                    owner.commentWriteView.snp.updateConstraints { make in
                        make.height.equalTo(height)
                    }
                    owner.commentTextView.alignCenterYText()
                }
            }
            .disposed(by: disposeBag)
        
        // 댓글 입력 시 키보드 내리기
        reactor.state
            .map { $0.isEndEditing }
            .distinctUntilChanged()
            .filter { $0 }
            .bind(with: self, onNext: { owner, _ in
                owner.commentTextView.text = "댓글을 입력하세요"
                owner.view.endEditing(true)
            })
            .disposed(by: disposeBag)
        
        // 게시글 삭제 시 pop
        reactor.state
            .map { $0.isDeleted }
            .distinctUntilChanged()
            .filter { $0 }
            .map { _ in }
            .bind(onNext: popViewController)
            .disposed(by: disposeBag)
        
        // 댓글 빈 칸일 시 버튼 비활성화
        reactor.state
            .map { $0.writeButtonEnable }
            .distinctUntilChanged()
            .bind(to: commentWriteButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.selectedComment }
            .distinctUntilChanged()
            .compactMap { $0 }
            .bind(with: self, onNext: { owner, communityComment in
                owner.presentCommentDetailViewController(nil, communityComment)
            })
            .disposed(by: disposeBag)
    }
}

extension QnADetailViewController: UITextViewDelegate {

    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        let isLogin = reactor!.currentState.isLogin
        if !isLogin {
            presentAlertVC(
                title: "로그인 후 이용가능한 서비스입니다",
                content: "입력하신 내용을 다시 확인해주세요",
                buttonTitle: "로그인 하러가기 ")
        }
        return reactor!.currentState.isLogin
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<QnADetailSection, QnADetailSectionItem>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            
            switch item {
            case .qnaPostCell(let qnaPost):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: QnAPostCell.identifier, for: indexPath) as? QnAPostCell else { return UICollectionViewCell() }
                
                self.postOptionView.parentVC = self
            
                let optionPostData = OptionPostData(id: qnaPost.id, content: qnaPost.content, title: qnaPost.title, category: qnaPost.category, isWrited: qnaPost.writed)
                
                cell.optionButton.rx.tap
                    .map { OptionReactor.Action.didTapOptionButton(.Post(optionPostData)) }
                    .bind(to: self.postOptionView.reactor!.action)
                    .disposed(by: self.disposeBag)
                
                cell.updateCell(qnaPost)
                cell.bindPhotoCollectionView(qnaPost.communityPhotos)
                
                if let url = qnaPost.myProfileImgUrl {
                    self.profileImageView.kf.setImage(with: URL(string: url))
                }
                
                
                self.reactor?.state
                    .map { $0.photoItem }
                    .distinctUntilChanged()
                    .bind(to: cell.photoCollectionView.rx.items(cellIdentifier: PhotoCell.identifier, cellType: PhotoCell.self)) { row, item, cell in
                        cell.isZoomEnabled = false
                        cell.imageView.kf.setImage(with: URL(string: item.photoUrl))
                        
                    }
                    .disposed(by: cell.disposeBag)
                
                cell.photoCollectionView.rx.itemSelected
                    .bind(with: self, onNext: { owner, indexPath in
                        owner.presentImagePinchVC(indexPath, images: qnaPost.communityPhotos)
                    })
                    .disposed(by: cell.disposeBag)
                
                
                return cell
            
                
            case .commentCell(let comment):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommentCell.identifier, for: indexPath) as? CommentCell else { return UICollectionViewCell() }
                
                // optionView에 comment 정보 전달
                if let comment = comment {
                    let optionData = OptionCommentData(id: comment.commentId, content: comment.content, isWrited: comment.writed, isCommunity: true)
                    
                    cell.optionButton.rx.tap
                        .map { OptionReactor.Action.didTapOptionButton(.Comment(optionData)) }
                        .bind(to: self.commentOptionView.reactor!.action)
                        .disposed(by: cell.disposeBag)
                    
                    // QnADetailReactor에 indexPathRow 전달
                    cell.optionButton.rx.tap
                        .map { QnADetailReactor.Action.didTapOptionButton(indexPath.row) }
                        .bind(to: self.reactor!.action)
                        .disposed(by: self.disposeBag)
                }
                
                cell.updateCommunityComment(comment)
                return cell
            }
            
        })
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            switch indexPath.section {
            case 0:
                guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: QnAPostHeaderView.identifier, for: indexPath) as? QnAPostHeaderView else { return UICollectionReusableView() }
                
                self.reactor?.state
                    .map { $0.category }
                    .bind(to: header.recommendLabel.rx.text)
                    .disposed(by: self.disposeBag)
                
                return header
            case 1:
                guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: QnACommentHeaderView.identifier, for: indexPath) as? QnACommentHeaderView else { return UICollectionReusableView() }
                
                self.reactor?.state
                    .map { $0.commentCount }
                    .compactMap { $0 }
                    .map { "+\($0)"}
                    .bind(to: header.commentCountLabel.rx.text)
                    .disposed(by: self.disposeBag)
                
                return header
            default:
                return nil
            }
        }
    }
    
    func configureQnAPostSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(268))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(268))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(14)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 46, leading: 16, bottom: 32, trailing: 16)
        sectionHeader.contentInsets = .init(top: 30, leading: 0, bottom: 0, trailing: 0)
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
    
    
    func configureQnACommentSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(102))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(102))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(20)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        sectionHeader.contentInsets = .init(top: 0, leading: 0, bottom: 12, trailing: 0)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
    
    func configureLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { section, _ in
            switch section {
            case 0:
                return self.configureQnAPostSection()
            case 1:
                return self.configureQnACommentSection()
            default:
                return nil
            }
            
        }
    }
}
