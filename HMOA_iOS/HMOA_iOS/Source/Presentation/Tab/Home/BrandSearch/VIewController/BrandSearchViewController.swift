//
//  BrandSearchViewController.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/03/16.
//

import UIKit
import SnapKit
import Then
import ReactorKit
import RxSwift
import RxCocoa

class BrandSearchViewController: UIViewController, View {
    typealias Reactor = BrandSearchReactor

    // MARK: - Properties
    private var dataSource: UICollectionViewDiffableDataSource<BrandListSection, BrandCell>?
    
    var disposeBag = DisposeBag()
    

    // MARK: - UI Component
    private lazy var backButton = UIButton().makeImageButton(UIImage(named: "backButton")!)
    
    private lazy var searchBar = UISearchBar().then {
        $0.showsBookmarkButton = true
        $0.setImage(UIImage(named: "clearButton"), for: .clear, state: .normal)
        $0.setImage(UIImage(named: "search")?.withTintColor(.customColor(.gray3)), for: .bookmark, state: .normal)
        $0.searchTextField.leftView = UIView()
        $0.searchTextField.backgroundColor = .white
        $0.searchTextField.textAlignment = .left
        $0.searchTextField.font = .customFont(.pretendard_light, 16)
        $0.placeholder = "브랜드 검색"
    }

    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout()).then {
        $0.register(BrandListHeaderView.self, forSupplementaryViewOfKind: SupplementaryViewKind.header, withReuseIdentifier: BrandListHeaderView.identifier)
        $0.register(BrandListCollectionViewCell.self, forCellWithReuseIdentifier: BrandListCollectionViewCell.identifier)
    }
    
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureSearchNavigationBar(backButton, searchBar: searchBar)
        configureCollectionViewDataSource()
    }
}

extension BrandSearchViewController {
    // MARK: - bind
    
    func bind(reactor: BrandSearchReactor) {

        // MARK: - Action
        rx.viewDidLoad
            .map { Reactor.Action.scrollCollectionView(1) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        collectionView.rx.willDisplayCell
            .filter { cellInfo in
                let isLastSection = cellInfo.at.section == self.collectionView.numberOfSections - 1
                let isFirstItem = cellInfo.at.item == 0
                return isLastSection && isFirstItem
            }
            .map { _ in
                let section = self.collectionView.numberOfSections
                return Reactor.Action.scrollCollectionView(section + 1)
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 뒤로가기 버튼 클릭
        backButton.rx.tap
            .map { Reactor.Action.didTapBackButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 브랜드 Cell 클릭
        collectionView.rx.itemSelected
            .map {
                let item = self.dataSource?.itemIdentifier(for: $0)
                switch item {
                case .BrandItem(let brand):
                    return brand
                case .none:
                    return nil
                }
            }
            .compactMap { $0 }
            .map { Reactor.Action.didTapItem($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 텍스트 입력
        searchBar.rx.text
            .orEmpty
            .map { Reactor.Action.updateSearchResult($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        // MARK: - State
 
        // CollectionView 바인딩
        reactor.state
            .map { $0.sections }
            .distinctUntilChanged()
            .asDriver(onErrorRecover: { _ in return .empty() })
            .drive(with: self, onNext: { owner, sections in
                guard let datasource = owner.dataSource else { return }
                var snapshot = NSDiffableDataSourceSnapshot<BrandListSection, BrandCell>()
                sections.forEach { section in
                    if !snapshot.sectionIdentifiers.contains(section) {
                        snapshot.appendSections([section])
                    }
                    snapshot.appendItems(section.items, toSection: section)
                }
                
                datasource.apply(snapshot)
            })
            .disposed(by: disposeBag)
        
        // 이전 화면으로 이동
        reactor.state
            .map { $0.isPopVC }
            .distinctUntilChanged()
            .filter { $0 }
            .asDriver(onErrorRecover: { _ in return .empty() })
            .drive(with: self, onNext: { owner,  _ in
                owner.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        // 브랜드 상세 페이지로 이동
        reactor.state
            .map { $0.selectedItem }
            .distinctUntilChanged()
            .compactMap { $0 }
            .asDriver(onErrorRecover: { _ in return .empty() })
            .drive(with: self, onNext: { owner, item in
                owner.presentBrandDetailViewController(item.brandId)
            })
            .disposed(by: disposeBag)
        
    }
    
    // MARK: - Configure
    
    private func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            let headerItemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(80)
            )
            let headerItem = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerItemSize,
                elementKind: SupplementaryViewKind.header,
                alignment: .top
            )
            
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .estimated(60),
                heightDimension: .absolute(32)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(32)
            )
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.interItemSpacing = .fixed(8)
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 12
            section.contentInsets = .init(top: 16, leading: 0, bottom: 24, trailing: 0)
            section.boundarySupplementaryItems = [headerItem]
            
            return section
        }
        return layout
    }
    
    private func configureCollectionViewDataSource() {
        dataSource = UICollectionViewDiffableDataSource<BrandListSection, BrandCell>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            switch item {
            case .BrandItem(let brand):
                
                guard let brandCell = collectionView.dequeueReusableCell(withReuseIdentifier: BrandListCollectionViewCell.identifier, for: indexPath) as? BrandListCollectionViewCell else { return UICollectionViewCell() }
                
                brandCell.updateCell(brand)
                
                return brandCell
            }
            
        })
        
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath -> UICollectionReusableView? in
            switch kind {
            case SupplementaryViewKind.header:
                let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: SupplementaryViewKind.header,
                    withReuseIdentifier: BrandListHeaderView.identifier,
                    for: indexPath) as! BrandListHeaderView
                
                if self.dataSource?.snapshot() != nil {
                    let sectionTitle = self.reactor!.currentState.sections[indexPath.section].consonant
                    headerView.updateUI(sectionTitle)
                }
                
                return headerView
                
            default:
                return nil
            }
        }
    }
}
