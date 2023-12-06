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
    lazy var layout = UICollectionViewFlowLayout()
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).then {
        $0.alwaysBounceVertical = true
        $0.register(MyLogCommentHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MyLogCommentHeaderView.identifier)
        $0.register(CommentCell.self, forCellWithReuseIdentifier: CommentCell.identifier)
    }
    
    var datasource: UICollectionViewDiffableDataSource<MyLogCommentSection, MyLogCommentSectionItem>!
    
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
        view.addSubview(collectionView)
    }
    
    private func setConstraints() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func bind(reactor: MyLogCommentReactor) {
        
        // Action
        
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
        
        // State
        
        // colectionView binding
        reactor.state
            .map { $0.items }
            .asDriver(onErrorRecover: { _ in .empty() })
            .drive(with: self) { owner, items in
                var snapshot = NSDiffableDataSourceSnapshot<MyLogCommentSection, MyLogCommentSectionItem>()
                
                snapshot.appendSections([.comment])
                
                items.perfume.forEach { snapshot.appendItems([.perfume($0)]) }
                items.community.forEach { snapshot.appendItems([.community($0)]) }
                
                DispatchQueue.main.async {
                    owner.datasource.apply(snapshot, animatingDifferences: false)
                }
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
            .distinctUntilChanged()
            .bind(onNext: presentDatailViewController)
            .disposed(by: disposeBag)
        
        // 커뮤니티 게시글로 push
        reactor.state
            .map { $0.communityId }
            .compactMap { $0 }
            .distinctUntilChanged()
            .bind(onNext: presentQnADetailVC)
            .disposed(by: disposeBag)
    }
}

extension MyLogCommentViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 102)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if reactor?.currentState.commentType == .liked(nil) {
            return .zero
            } else {
                return CGSize(width: view.frame.width, height: 44)
            }
    }
    
    func configureDatasource() {
        datasource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommentCell.identifier, for: indexPath) as? CommentCell else {
                return UICollectionViewCell()
            }
            
            switch item {
            case .perfume(let comment), .liked(let comment):
                cell.updateCell(comment)
            case .community(let comment):
                cell.updateCommunityComment(comment)
            }
            
            cell.updateForMyLogComment()
            
            return cell
        })
        
        datasource.supplementaryViewProvider = { collectionView, kind, indexPath in
            
            if self.reactor?.currentState.commentType == .liked(nil) {
                return nil
            }
            
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
