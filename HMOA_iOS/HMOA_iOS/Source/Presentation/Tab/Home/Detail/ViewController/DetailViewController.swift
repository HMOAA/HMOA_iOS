//
//  DetailViewController.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/02/04.
//

import UIKit
import SnapKit
import Then
import ReactorKit
import RxSwift
import RxCocoa

class DetailViewController: UIViewController, View {
    
    // MARK: - Properties
    
    var disposeBag = DisposeBag()
    var perfumeId: Int = 0
    
    lazy var DetailReactor = DetailViewReactor(perfumeId)
    
    private var dataSource: UICollectionViewDiffableDataSource<DetailSection, DetailSectionItem>!

    let detailView = DetailView()
    
    let bottomView = DetailBottomView()
    
    let homeBarButton = UIButton().makeImageButton(UIImage(named: "homeNavi")!)
    let searchBarButton = UIButton().makeImageButton(UIImage(named: "search")!)
    let backBarButton = UIButton().makeImageButton(UIImage(named: "backButton")!)
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureCollectionViewDataSource()
        configreNavigationBar()
        bind(reactor: DetailReactor)
    }
}

// MARK: - Functions
extension DetailViewController {
    
    // MARK: - Bind
    
    func bind(reactor: DetailViewReactor) {
        
        // MARK: - Action
        
        // collectionView 아이템 클릭
        detailView.collectionView.rx.itemSelected
            .map { reactor.currentState.sections[$0.section].items[$0.item]}
            .map { Reactor.Action.didTapCell($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 댓글 작성 버튼 클릭
        bottomView.wirteButton.rx.tap
            .map { Reactor.Action.didTapWriteButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 뒤로가기 버튼 클릭
        backBarButton.rx.tap
            .map { Reactor.Action.didTapBackButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 홈 버튼 클릭
        homeBarButton.rx.tap
            .map { Reactor.Action.didTapHomeButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 검색 버튼 클릭
        
        searchBarButton.rx.tap
            .map { Reactor.Action.didTapSearchButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: - State
        
        // collectionView 바인딩
        reactor.state
            .map { $0.sections }
            .asDriver(onErrorRecover: { _ in return .empty() })
            .drive(with: self, onNext: { owner, sections in
                var snapshot = NSDiffableDataSourceSnapshot<DetailSection, DetailSectionItem>()
                snapshot.appendSections(sections)
                
                sections.forEach { section in
                    snapshot.appendItems(section.items, toSection: section)
                }
                DispatchQueue.main.async {
                    owner.dataSource.apply(snapshot)
                }
            }).disposed(by: disposeBag)
        
        // 댓글 전체 보기 페이지로 이동
        reactor.state
            .map { $0.persentCommentPerfumeId }
            .distinctUntilChanged()
            .compactMap { $0 }
            .bind(onNext: presentCommentViewContorller)
            .disposed(by: disposeBag)
        
        // 댓글 디테일 페이지로 이동
        reactor.state
            .map { $0.presentCommentId }
            .distinctUntilChanged()
            .compactMap { $0 }
            .bind(onNext: presentCommentDetailViewController)
            .disposed(by: disposeBag)
        
        // 향수 디테일 페이지로 이동
        reactor.state
            .map { $0.presentPerfumeId }
            .distinctUntilChanged()
            .compactMap { $0 }
            .bind(onNext: presentDatailViewController)
            .disposed(by: disposeBag)
        
        // 댓글 작성 페이지로 이동
        
        reactor.state
            .map { $0.isPresentCommentWirteVC }
            .distinctUntilChanged()
            .compactMap { $0 }
            .bind(onNext: presentCommentWriteViewController)
            .disposed(by: disposeBag)
        
        // 홈 페이지로 이동
        reactor.state
            .map { $0.isPopRootVC }
            .distinctUntilChanged()
            .filter { $0 }
            .map { _ in }
            .bind(onNext: popViewController) // 임시로 Pop
            .disposed(by: disposeBag)
        
        // 뒤로 이동
        reactor.state
            .map { $0.isPopVC}
            .distinctUntilChanged()
            .filter { $0 }
            .map { _ in }
            .bind(onNext: self.popViewController)
            .disposed(by: disposeBag)
        
        // 검색 페이지로 이동
        
        reactor.state
            .map { $0.isPresentSearchVC }
            .do(onNext: {
                print($0)
            })
            .distinctUntilChanged()
            .filter { $0 }
            .map { _ in }
            .bind(onNext: presentSearchViewController)
            .disposed(by: disposeBag)
    }
    
    func configureCollectionViewDataSource() {
        dataSource = UICollectionViewDiffableDataSource<DetailSection, DetailSectionItem>(collectionView: detailView.collectionView, cellProvider: { collectionView, indexPath, item in
            
            switch item {
            case .topCell(let detail, _):
                guard let perfumeInfoCell = collectionView.dequeueReusableCell(withReuseIdentifier: PerfumeInfoCell.identifier, for: indexPath) as? PerfumeInfoCell else { return UICollectionViewCell() }
                
                perfumeInfoCell.updateCell(detail)
                // 하단 뷰 향수 좋아요 버튼 클릭시 액션 전달
//                self.bottomView.likeButton.rx.tap
//                    .map { _ in .didTapPerfumeLikeButton }
//                    .bind(to: perfumeInfoCell.reactor!.action)
//                    .disposed(by: self.disposeBag)
                
                // perfumeInfoReactor의 향수 좋아요 상태 변화
                perfumeInfoCell.reactor?.state
                    .map { $0.isLikePerfume }
                    .distinctUntilChanged()
                    .bind(to: self.bottomView.likeButton.rx.isSelected)
                    .disposed(by: self.disposeBag)
                
                return perfumeInfoCell
            case .commentCell(let comment, _):
                guard let commentCell = collectionView.dequeueReusableCell(withReuseIdentifier: CommentCell.identifier, for: indexPath) as? CommentCell else { return UICollectionViewCell() }
                
                commentCell.updateCell(comment)
                return commentCell
            case .recommendCell(let recommend, _):
                guard let similarCell = collectionView.dequeueReusableCell(withReuseIdentifier: SimilarCell.identifier, for: indexPath) as? SimilarCell else { return UICollectionViewCell() }
                
                similarCell.updateUI(recommend)
                return similarCell

            }
        })
        dataSource.supplementaryViewProvider = {collectionView, kind, indexPath -> UICollectionReusableView in
            var header = UICollectionReusableView()
            
            switch indexPath.section {
            case 1:
                guard let commentHeader = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CommentHeaderView.identifier, for: indexPath) as? CommentHeaderView else { return UICollectionReusableView() }
                
                header = commentHeader
            default:
                guard let similarHeader = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SimilarHeaderView.identifier, for: indexPath) as? SimilarHeaderView else { return UICollectionReusableView() }
                
                header = similarHeader
            }
            
            if kind == UICollectionView.elementKindSectionFooter {
                guard let commentFooter = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: CommentFooterView.identifier, for: indexPath) as? CommentFooterView else { return UICollectionReusableView() }
                
                commentFooter.reactor = self.DetailReactor
                
                return commentFooter
            } else {
                return header
            }
        }
    }
    
    func configureUI() {
                        
        [   detailView,
            bottomView  ]   .forEach { view.addSubview($0) }
        
        detailView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(bottomView.snp.top)
        }
        
        bottomView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(83)
        }
    }
    
    func configreNavigationBar() {
        setNavigationBarTitle("조말론 런던")
        
        let backBarButtonItem = self.navigationItem.makeImageButtonItem(backBarButton)
        let homeBarButtonItem = self.navigationItem.makeImageButtonItem(homeBarButton)
        let searchBarButtonItem = self.navigationItem.makeImageButtonItem(searchBarButton)
        
        self.navigationItem.leftBarButtonItems = [backBarButtonItem, spacerItem(15), homeBarButtonItem]
        self.navigationItem.rightBarButtonItems = [searchBarButtonItem]
    }
}
