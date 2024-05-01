//
//  MyLogCommentViewController.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 11/20/23.
//

import Foundation

import Then
import SnapKit
import RxCocoa
import RxSwift
import ReactorKit

class MyLogCommentViewController: UIViewController, View {
    
    // MARK: - UIComponents
    private lazy var layout = UICollectionViewFlowLayout()
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).then {
        $0.alwaysBounceVertical = true
        $0.register(MyLogCommentHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MyLogCommentHeaderView.identifier)
        $0.register(CommentCell.self, forCellWithReuseIdentifier: CommentCell.identifier)
    }
    
    let noLikedView = NoLoginEmptyView(title:
                                                """
                                                좋아요를 누른 댓글이
                                                없습니다
                                                """,
                                             subTitle:
                                                """
                                                좋아하는 향수에 좋아요를 눌러주세요
                                                """,
                                            buttonHidden: true).then {
        $0.isHidden = true
    }
    
    let noWritedCommentView = NoLoginEmptyView(title:
                                                """
                                                작성한 댓글이
                                                없습니다
                                                """,
                                             subTitle:
                                                """
                                                좋아하는 향수에 댓글을 작성해주세요
                                                """,
                                            buttonHidden: true).then {
        $0.isHidden = true
    }
    
    private var datasource: UICollectionViewDiffableDataSource<MyLogCommentSection, MyLogCommentSectionItem>?
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        setAddView()
        setConstraints()
        configureDatasource()
    }
    
    //MARK: - SetUp
    private func setUpUI() {
        view.backgroundColor = .white
    }
    
    private func setAddView() {
        [
            collectionView,
            noLikedView,
            noWritedCommentView
        ]   .forEach { view.addSubview($0) }
    }
    
    private func setConstraints() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        noLikedView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        noWritedCommentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
    // MARK: - Bind
    
    func bind(reactor: MyLogCommentReactor) {
        
        // MARK: - Action
        
        // viewDidLoad
        Observable.just(())
            .map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // setDelegate
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        // WillDisplayCell
        collectionView.rx.willDisplayCell
            .map {
                let currentItem = $0.at.item
                if (currentItem + 1) % 10 == 0 && currentItem != 0 {
                    return currentItem / 10 + 1
                }
                return nil
            }
            .compactMap { $0 }
            .map { Reactor.Action.willDisplayCell($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // cell 선택
        collectionView.rx.itemSelected
            .map { Reactor.Action.didSelectedCell($0.row) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: - State
        
        // colectionView binding
        reactor.state
            .map { $0.items }
            .distinctUntilChanged()
            .asDriver(onErrorRecover: { _ in .empty() })
            .drive(with: self) { owner, items in
                
                if case .liked(_) = reactor.currentState.commentType {
                    print("asdf22")
                    print(items.perfume.isEmpty && items.community.isEmpty)
                    if items.perfume.isEmpty && items.community.isEmpty {
                        owner.noLikedView.isHidden = false
                        owner.collectionView.isHidden = true
                    } else {
                        owner.noLikedView.isHidden = true
                        owner.collectionView.isHidden = false
                    }
                }
                
                if case .perfume(_) = reactor.currentState.commentType {
                    print("asdf")
                    print(items.perfume.isEmpty && items.community.isEmpty)
                    if items.perfume.isEmpty && items.community.isEmpty {
                        owner.noWritedCommentView.isHidden = false
                        owner.collectionView.isHidden = true
                    } else {
                        owner.noWritedCommentView.isHidden = true
                        owner.collectionView.isHidden = false
                    }
                }
                
                guard let datasource = owner.datasource else { return }
                var snapshot = NSDiffableDataSourceSnapshot<MyLogCommentSection, MyLogCommentSectionItem>()
                snapshot.appendSections([.comment])
                
                items.perfume.forEach { snapshot.appendItems([.perfume($0)]) }
                items.community.forEach { snapshot.appendItems([.community($0)]) }
                
                datasource.apply(snapshot, animatingDifferences: false)
            }
            .disposed(by: disposeBag)
        
        
        // navigation title binding
        reactor.state
            .map { $0.navigationTitle }
            .bind(onNext: setBackItemNaviBar)
            .disposed(by: disposeBag)
        
        // 향수 상세 정보로 push
        reactor.state
            .map { $0.perfumeId }
            .compactMap { $0 }
            .asDriver(onErrorRecover: { _ in .empty() })
            .drive(with: self, onNext: { owner, id in
                owner.presentDatailViewController(id)
            })
            .disposed(by: disposeBag)
        
        // 커뮤니티 게시글로 push
        reactor.state
            .map { $0.communityId }
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .bind(onNext: presentCommunityDetailVC)
            .disposed(by: disposeBag)
    }
}

extension MyLogCommentViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 102)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 44)
    }
    
    private func configureDatasource() {
        datasource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommentCell.identifier, for: indexPath) as? CommentCell else {
                return UICollectionViewCell()
            }
            
            switch item {
            case .perfume(let comment), .liked(let comment), .community(let comment):
                cell.updateForMyLogComment(comment!)
            }
            
            return cell
        })
        
        datasource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            
            switch indexPath.section {
            case 0:
                guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MyLogCommentHeaderView.identifier, for: indexPath) as? MyLogCommentHeaderView else { return UICollectionReusableView() }
                
                header.tagListView.tagViews[0].rx.tap
                .map { Reactor.Action.didTapPerfumeTab }
                .bind(to: self.reactor!.action)
                .disposed(by: header.disposeBag)
                
                header.tagListView.tagViews[1].rx.tap
                .map { Reactor.Action.didTapCommunityTab }
                .bind(to: self.reactor!.action)
                .disposed(by: header.disposeBag)
                
                return header
                
            default:
                return UICollectionReusableView()
            }
        }
    }

}
