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

    private var dataSource: UICollectionViewDiffableDataSource<CommentSection, CommentSectionItem>!
    
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
        Observable.just(())
            .map { Reactor.Action.viewDidLoad }
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
        
        // MARK: - State
        // collectionView 바인딩
        reactor.state
            .map { $0.commentItems }
            .distinctUntilChanged()
            .filter { !$0.isEmpty }
            .asDriver(onErrorRecover: { _ in return .empty() })
            .drive(with: self, onNext: { owner, item in
    
                var snapshot = NSDiffableDataSourceSnapshot<CommentSection, CommentSectionItem>()
                snapshot.appendSections([.comment])
            
                item.forEach { snapshot.appendItems([.commentCell($0)]) }
                
                DispatchQueue.main.async {
                    owner.dataSource.apply(snapshot)
                }
            }).disposed(by: disposeBag)
        
        // 댓글 디테일 페이지로 이동
        reactor.state
            .map { $0.selectedComment }
            .distinctUntilChanged()
            .compactMap { $0 }
            .bind(onNext: presentCommentDetailViewController)
            .disposed(by: disposeBag)
        
        // 댓글 작성 페이지로 이동
        reactor.state
            .map { $0.isPresentCommentWriteVC }
            .distinctUntilChanged()
            .compactMap { $0 }
            .bind(onNext: presentCommentWriteViewController)
            .disposed(by: disposeBag)
        
        // 내비게이션 타이틀 설정
        reactor.state
            .map { $0.navigationTitle }
            .bind(onNext: setBackItemNaviBar)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.commentType }
            .filter { $0 != .detail }
            .bind(with: self) { owner, _ in
                owner.bottomView.isHidden = true
            }.disposed(by: disposeBag)
    }
    
    func bindHeader() {
                
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
            .map { $0.commentType }
            .filter { $0 != .detail }
            .bind(with: self) { owner, _ in
                owner.header.isHidden = true
                owner.collectionView.snp.remakeConstraints { make in
                    make.leading.trailing.bottom.equalToSuperview()
                    make.top.equalTo(owner.view.safeAreaLayoutGuide)
                }
            }.disposed(by: disposeBag)
        
    }
    
    func configureCollectionViewDataSource() {
        
        dataSource = UICollectionViewDiffableDataSource<CommentSection, CommentSectionItem>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            
            switch item {
            case .commentCell(let comment):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommentCell.identifier, for: indexPath) as? CommentCell else { return UICollectionViewCell() }
                
                cell.updateCell(comment)
                
                cell.optionButton.rx.tap
                    .map { OptionReactor.Action.didTapOptionButton(comment.id, comment.content, nil, "Comment", nil, comment.writed) }
                    .bind(to: self.optionView.reactor!.action)
                    .disposed(by: self.disposeBag)
                
                return cell
            }
        })
        
        dataSource.supplementaryViewProvider =  { collectionView, kind, indexPath -> UICollectionReusableView in
            
            switch indexPath.section {
            case 0:
                guard let commentListTopView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CommentListTopView.identifier, for: indexPath) as? CommentListTopView else { return UICollectionReusableView() }
                
                self.header = commentListTopView
                self.bindHeader()
                
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
