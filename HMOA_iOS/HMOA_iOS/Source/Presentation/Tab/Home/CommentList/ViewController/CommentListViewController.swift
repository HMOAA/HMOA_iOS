//
//  CommentListViewController.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/02/21.
//

import UIKit
import SnapKit
import Then
import ReactorKit
import RxSwift
import RxCocoa
import RxAppState

class CommentListViewController: UIViewController, View {
    
    // MARK: - Properties
    var perfumeId: Int = 0

    private var dataSource: UICollectionViewDiffableDataSource<CommentSection, CommentSectionItem>?
    
    var disposeBag = DisposeBag()
    
    

    // MARK: - UI Component
    
    let bottomView = CommentListBottomView()
    
    lazy var layout = UICollectionViewFlowLayout()
    private var header: CommentListTopView!
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).then {
        $0.alwaysBounceVertical = true
        $0.register(CommentCell.self, forCellWithReuseIdentifier: CommentCell.identifier)
        $0.register(CommentListTopView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CommentListTopView.identifier)
    }
    
    lazy var optionView = OptionView().then {
        $0.reactor = OptionReactor()
        $0.parentVC = self
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureCollectionViewDataSource()
    }
}

extension CommentListViewController {

    // MARK: - Bind
    
    func bind(reactor: CommentListReactor) {
        
        // MARK: - Action
        
        // ViewDidLoad
        LoginManager.shared.isLogin
            .distinctUntilChanged()
            .map { Reactor.Action.viewDidLoad($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // WillDisplayCell
        collectionView.rx.willDisplayCell
            .map {
                let currentItem = $0.at.item
                if (currentItem + 1) %  10 == 0 && currentItem != 0 {
                    return currentItem / 10 + 1
                }
                return nil
            }
            .compactMap { $0 }
            .map { Reactor.Action.willDisplayCell($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // collectionView item 선택
        collectionView.rx.itemSelected
            .map { Reactor.Action.didTapCell($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        // 댓글 작성 버튼 클릭
        bottomView.writeButton.rx.tap
            .map { Reactor.Action.didTapWriteButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 댓글 삭제 터치
        optionView.reactor?.state
            .map { $0.isTapDelete }
            .distinctUntilChanged()
            .filter { $0 }
            .map { _ in Reactor.Action.didDeleteComment }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: - State
        
        // collectionView 바인딩
        reactor.state
            .map { $0.commentItems }
            .distinctUntilChanged()
            .asDriver(onErrorRecover: { _ in return .empty() })
            .drive(with: self, onNext: { owner, item in
                guard let dataSource = owner.dataSource else { return }
                var snapshot = NSDiffableDataSourceSnapshot<CommentSection, CommentSectionItem>()
                snapshot.appendSections([.comment])
            
                item.forEach { snapshot.appendItems([.commentCell($0)]) }
                
                DispatchQueue.main.async {
                    dataSource.apply(snapshot, animatingDifferences: false)
                }
            }).disposed(by: disposeBag)
        
        // 댓글 디테일 페이지로 이동
        reactor.state
            .map { $0.selectedComment }
            .distinctUntilChanged()
            .compactMap { $0 }
            .bind(with: self, onNext: { owner, comment in
                owner.presentCommentDetailViewController(comment, nil, reactor.service)
            })
            .disposed(by: disposeBag)
        
        // 댓글 작성 페이지로 이동
        reactor.state
            .map { $0.isPresentCommentWriteVC }
            .distinctUntilChanged()
            .compactMap { $0 }
            .bind(with: self, onNext: { owner, _ in
                owner.presentCommentWriteViewController(.commentList(reactor))
            })
            .disposed(by: disposeBag)
        
        // 내비게이션 타이틀 설정
        reactor.state
            .map { $0.navigationTitle }
            .bind(onNext: setBackItemNaviBar)
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
    
    func bindHeader(_ header: CommentListTopView) {
                
        // MARK: - bindHeader - Action
        
        // 좋아요순 버튼 클릭
        header.likeSortButton.rx.tap
            .map { Reactor.Action.didTapLikeSortButton }
            .bind(to: reactor!.action)
            .disposed(by: disposeBag)
        
        // 최신순 버튼 클릭
        header.recentSortButton.rx.tap
            .map { Reactor.Action.didTapRecentSortButton }
            .bind(to: reactor!.action)
            .disposed(by: disposeBag)
        
        //댓글 개수 
        reactor?.state
            .map { $0.commentCount }
            .distinctUntilChanged()
            .map { "+" + String($0) }
            .bind(to: header.commentCountLabel.rx.text )
            .disposed(by: disposeBag)
        
        reactor?.state
            .map { $0.sortType }
            .map { $0 == "Latest" }
            .bind(onNext: { isLatest in
                header.recentSortButton.isSelected = isLatest
                header.likeSortButton.isSelected = !isLatest
            })
            .disposed(by: disposeBag)
    }
    
    func configureCollectionViewDataSource() {
        
        dataSource = UICollectionViewDiffableDataSource<CommentSection, CommentSectionItem>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            
            switch item {
            case .commentCell(let comment):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommentCell.identifier, for: indexPath) as? CommentCell else { return UICollectionViewCell() }
                
                
                let optionData = OptionCommentData(id: comment.id, content: comment.content, isWrited: comment.writed, isCommunity: false)
                
                cell.optionButton.rx.tap
                    .map { OptionReactor.Action.didTapOptionButton(.Comment(optionData)) }
                    .bind(to: self.optionView.reactor!.action)
                    .disposed(by: self.disposeBag)
                
                // QnADetailReactor에 indexPathRow 전달
                cell.optionButton.rx.tap
                    .map { CommentListReactor.Action.didTapOptionButton(comment.id) }
                    .bind(to: self.reactor!.action)
                    .disposed(by: self.disposeBag)
                
                cell.updateCell(comment)
                return cell
            }
        })
        
        dataSource?.supplementaryViewProvider =  { collectionView, kind, indexPath -> UICollectionReusableView in
            
            switch indexPath.section {
            case 0:
                guard let commentListTopView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CommentListTopView.identifier, for: indexPath) as? CommentListTopView else { return UICollectionReusableView() }
                
                self.header = commentListTopView
                self.bindHeader(commentListTopView)
                
                return commentListTopView
                
            default:
                return UICollectionReusableView()
            }
        }
    }
    
    func configureUI() {
        view.backgroundColor = .white
        
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        [   collectionView,
            bottomView,
            optionView
        ]   .forEach { view.addSubview($0) }
        
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(bottomView.snp.top)
        }
        
        bottomView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(83)
        }
        
        optionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension CommentListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 102)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 44)
    }
}
