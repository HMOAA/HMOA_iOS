//
//  DrawerViewController.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/01/12.
//

import UIKit

import SnapKit
import Then
import RxCocoa
import ReactorKit

class LikeViewController: UIViewController, View {
    
    //MARK: - Property
    let reactor = LikeReactor()
    var disposeBag = DisposeBag()
    
    private var cardDatasource: UICollectionViewDiffableDataSource<LikeSection, Like>!
    private var listDatasource: UICollectionViewDiffableDataSource<LikeSection, Like>!

    
    lazy var cardCollectionView = UICollectionView(frame: .zero,
                                                   collectionViewLayout: configureCardLayout()).then {
        $0.isScrollEnabled = false
        $0.showsHorizontalScrollIndicator = false
        $0.register(LikeCardCell.self,
                    forCellWithReuseIdentifier: LikeCardCell.identifier)
        $0.register(LikeHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: LikeHeaderView.identifier)
    }
    
    lazy var listCollectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: configureListLayout()).then {
        $0.isHidden = true
        $0.register(LikeHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: LikeHeaderView.identifier)
        $0.register(LikeListCell.self, forCellWithReuseIdentifier: LikeListCell.identifier)
    }
    
    lazy var noLikeView = UIView().then {
        $0.isHidden = true
    }
    
    lazy var perfumeImageView = UIImageView().then {
        $0.image = UIImage(named: "noLike")
    }
    
    lazy var noLikeLabel = UILabel().then {
        $0.setLabelUI("저장된 향수가 없습니다", font: .pretendard_medium, size: 24, color: .black)
    }
    
    lazy var saveLabel = UILabel().then {
        $0.setLabelUI("좋아하는 향수를 저장해주세요", font: .pretendard, size: 16, color: .black)
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        setAddView()
        setConstraints()
        
        configureCardDataSource()
        configureListDataSource()
        
        bind(reactor: reactor)
    }
    
    //MARK: - SetUp
    private func setUpUI() {
        view.backgroundColor = UIColor.white
        setNavigationColor()
        setNavigationBarTitle("저장")
    }
    
    private func setAddView() {
        
        [
            perfumeImageView,
            noLikeLabel,
            saveLabel
        ]   .forEach { noLikeView.addSubview($0) }
        
        
        [
            listCollectionView,
            cardCollectionView,
            noLikeView
        ]   .forEach { view.addSubview($0) }
    }
    
    private func setConstraints() {
        
        noLikeView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        perfumeImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(117)
        }
        
        noLikeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(perfumeImageView.snp.bottom).offset(35)
        }
        
        saveLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(noLikeLabel.snp.bottom).offset(62)
        }
        
        cardCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(510)
            make.top.equalTo(listCollectionView)

        }
        
        listCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.trailing.equalToSuperview().inset(8)
            make.bottom.equalToSuperview()
        }
        
    }
    //MARK: - Bind
    func bind(reactor: LikeReactor) {
        //Input
        
        rx.viewWillAppear
            .map { _ in LikeReactor.Action.viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        cardCollectionView.rx.itemSelected
            .map { LikeReactor.Action.didTapCollectionViewItem($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        listCollectionView.rx.itemSelected
            .map { LikeReactor.Action.didTapCollectionViewItem($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    
        
        //Output
        
        //CollectionView Binding
        reactor.state
            .map { $0.sectionItem }
            .distinctUntilChanged()
            .asDriver(onErrorRecover: { _ in return .empty() })
            .drive(with: self, onNext: { owner, item in

                var cardSnapshot = NSDiffableDataSourceSnapshot<LikeSection, Like>()
                cardSnapshot.appendSections([.main])
                cardSnapshot.appendItems(item, toSection: .main)
                
                var listSnapshot = NSDiffableDataSourceSnapshot<LikeSection, Like>()
                listSnapshot.appendSections([.main])
                listSnapshot.appendItems(item, toSection: .main)
                
                DispatchQueue.main.async {
                    owner.cardDatasource.apply(cardSnapshot, animatingDifferences: true)
                    owner.listDatasource.apply(listSnapshot, animatingDifferences: true)
                }
            })
            .disposed(by: disposeBag)

        // 향수 디테일 페이지로 이동
        reactor.state
            .map { $0.selectedPerfumeId }
            .distinctUntilChanged()
            .compactMap { $0 }
            .bind(with: self, onNext: { owner, id in
                owner.presentDatailViewController(id)
            })
            .disposed(by: disposeBag)
        
        // 좋아요한 향수 없을 시 뷰 보여주기
        reactor.state
            .map { $0.isHiddenNoLikeView }
            .distinctUntilChanged()
            .bind(with: self, onNext: { owner, isHidden in
                if let isHidden = isHidden {
                    owner.noLikeView.isHidden = isHidden
                    if reactor.currentState.isSelectedCard {
                        owner.cardCollectionView.isHidden = !isHidden
                    } else {
                        owner.listCollectionView.isHidden = !isHidden
                    }
                } else {
                    owner.noLikeView.isHidden = true
                    owner.cardCollectionView.isHidden = true
                    owner.listCollectionView.isHidden = true
                }
            })
            .disposed(by: disposeBag)
        
        // 마지막 아이템 삭제시 왼쪽으로 이동
        reactor.state
            .map { $0.isDeletedLast }
            .filter { $0 }
            .bind(with: self) { owner, _ in
                let row = reactor.currentState.currentRow
                if row > 0 {
                    let targetIndexPath = IndexPath(row: row - 1, section: 0)
                    owner.cardCollectionView.scrollToItem(at: targetIndexPath, at: .centeredHorizontally, animated: true)
                }
            }
            .disposed(by: disposeBag)
      
    }
    
    func bindHeaderView(headerView: LikeHeaderView) {
        
        //카드버튼 터치 이벤트
        headerView.cardButton.rx.tap
            .map { LikeReactor.Action.didTapCardButton }
            .bind(to: self.reactor.action)
            .disposed(by: headerView.disposeBag)
        
        headerView.listButton.rx.tap
            .map { LikeReactor.Action.didTapListButton }
            .bind(to: self.reactor.action)
            .disposed(by: headerView.disposeBag)
        
        reactor.state
            .map { $0.isSelectedList }
            .distinctUntilChanged()
            .bind(to: headerView.listButton.rx.isSelected, cardCollectionView.rx.isHidden)
            .disposed(by: headerView.disposeBag)
        
        //listCollectionView 보여주기
        reactor.state
            .map { $0.isSelectedCard }
            .distinctUntilChanged()
            .bind(to: headerView.cardButton.rx.isSelected, listCollectionView.rx.isHidden)
            .disposed(by: headerView.disposeBag)
    }
    
}

extension LikeViewController {
    
    func configureCardDataSource() {
        cardDatasource = UICollectionViewDiffableDataSource<LikeSection, Like>(collectionView: cardCollectionView, cellProvider: { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LikeCardCell.identifier, for: indexPath) as? LikeCardCell
            else { return UICollectionViewCell() }
    
            cell.xButton.rx.tap
                .map { Reactor.Action.didTapXButton }
                .bind(to: self.reactor.action)
                .disposed(by: cell.disposeBag)
                    
            
            cell.updateCell(item: item)
            return cell
        })
        
        cardDatasource.supplementaryViewProvider = { collectionView, kind, indexPath in
            self.configureHeader(collectionView, kind, indexPath)
        }
    }
    
    func configureListDataSource() {
        listDatasource = UICollectionViewDiffableDataSource<LikeSection, Like> (collectionView: listCollectionView, cellProvider: { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LikeListCell.identifier, for: indexPath) as? LikeListCell
            else { return UICollectionViewCell() }
            
            cell.updateCell(item: item)
            return cell
        })
        
        listDatasource.supplementaryViewProvider = { collectionView, kind, indexPath in
            self.configureHeader(collectionView, kind, indexPath)
        }
    }
    
    private func configureCardLayout() -> UICollectionViewCompositionalLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(460))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.79), heightDimension: .fractionalHeight(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.interGroupSpacing = 16
        
        section.visibleItemsInvalidationHandler = { items, contentOffset, environment in
            let currentPage = Int((contentOffset.x / environment.container.contentSize.width).rounded(.up))
            
            self.reactor.action.onNext(.didChangeCurrentPage(currentPage))
        }
        
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(44)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .topTrailing)
        
        sectionHeader.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0)
        section.boundarySupplementaryItems = [sectionHeader]
        
        let layout = UICollectionViewCompositionalLayout(section: section)

        return layout
    }
    
    private func configureListLayout() -> UICollectionViewCompositionalLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.33), heightDimension: .fractionalWidth(0.33))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.23))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(44)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .topTrailing)
        
        section.boundarySupplementaryItems = [sectionHeader]
        
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func configureHeader(_ collectionView: UICollectionView, _ kind: String, _ indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: LikeHeaderView.identifier, for: indexPath) as? LikeHeaderView else { return UICollectionReusableView() }
        
        self.bindHeaderView(headerView: header)
        
        return header
    }
}

