//
//  MagazineViewController.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2/22/24.
//

import UIKit
import RxCocoa
import ReactorKit
import RxSwift

class MagazineViewController: UIViewController, View {
    
    private lazy var magazineCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout()).then {
        $0.register(MagazineMainCell.self, forCellWithReuseIdentifier: MagazineMainCell.identifier)
        $0.register(MagazineNewPerfumeCell.self, forCellWithReuseIdentifier: MagazineNewPerfumeCell.identifier)
        $0.register(MagazineTopReviewCell.self, forCellWithReuseIdentifier: MagazineTopReviewCell.identifier)
        $0.register(MagazineAllCell.self, forCellWithReuseIdentifier: MagazineAllCell.identifier)
        
        $0.register(MagazineHeaderView.self, forSupplementaryViewOfKind: SupplementaryViewKind.header, withReuseIdentifier: MagazineHeaderView.identifier)
    }
    
    // MARK: - Properties
    private var dataSource: UICollectionViewDiffableDataSource<MagazineSection, MagazineItem>?
    
    private var sections = [MagazineSection]()
    
    var disposeBag = DisposeBag()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(magazineCollectionView)
        setUI()
        setConstraints()
        configureDataSource()
    }
    
    // MARK: - Bind
    
    func bind(reactor: MagazineReactor) {
        // MARK: Action
        
        // magazine item 터치
        magazineCollectionView.rx.itemSelected
            .filter { $0.section == 0 || $0.section == 3 }
            .map { Reactor.Action.didTapMagazineCell($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: State
        
        // MainBannerItems 변화 감지
        reactor.state
            .map { $0.mainBannerItems }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] items in
                self?.updateSnapshot(forSection: .mainBanner, withItems: items)
            })
            .disposed(by: disposeBag)
        
        // NewPerfumeItems 변화 감지
        reactor.state
            .map { $0.newPerfumeItems }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] items in
                self?.updateSnapshot(forSection: .newPerfume, withItems: items)
            })
            .disposed(by: disposeBag)
        
        // TopReviewItems 변화 감지
        reactor.state
            .map { $0.topReviewItems }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] items in
                self?.updateSnapshot(forSection: .topReview, withItems: items)
            })
            .disposed(by: disposeBag)
        
        // AllMagazineItems 변화 감지
        reactor.state
            .map { $0.allMagazineItems }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] items in
                self?.updateSnapshot(forSection: .allMagazine, withItems: items)
            })
            .disposed(by: disposeBag)
        
        // MagazineDetailVC로 push
        reactor.state
            .map { $0.selectedMagazine }
            .asDriver(onErrorRecover: { _ in return .empty() })
            .drive(with: self, onNext: { owner, _ in
                owner.presentMagazineDetailViewController()
            })
            .disposed(by: disposeBag)
    }
    
    private func setUI() {
        title = "Magazine"
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.customFont(.pretendard_bold, 20),
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        self.navigationController?.view.backgroundColor = .clear
        
        magazineCollectionView.contentInsetAdjustmentBehavior = .never
        view.backgroundColor = .white
    }
    
    private func setConstraints() {
        magazineCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let availableLayoutWidth = layoutEnvironment.container.effectiveContentSize.width
            let centerImageWidth = availableLayoutWidth * 0.92
            let centerImageHeight = centerImageWidth / 328 * 376
            
            let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(60))
            let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize, elementKind: SupplementaryViewKind.header, alignment: .top)
            
            let section = self.sections[sectionIndex]
            switch section {
            case .mainBanner:
                let backgroundDecoration = NSCollectionLayoutDecorationItem.background(elementKind: SupplementaryViewKind.background)
                
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(centerImageHeight))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.92), heightDimension: .estimated(centerImageHeight))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 115, leading: 0, bottom: 22, trailing: 0)
                section.orthogonalScrollingBehavior = .groupPagingCentered
                section.interGroupSpacing = 8
                section.decorationItems = [backgroundDecoration]
                
                return section
                
            case .newPerfume:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(219))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(155), heightDimension: .estimated(219))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.boundarySupplementaryItems = [headerItem]
                section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 16, bottom: 20, trailing: 16)
                section.interGroupSpacing = 8
                
                return section
                
            case .topReview:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(193))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(296), heightDimension: .estimated(193))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.boundarySupplementaryItems = [headerItem]
                section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 16, bottom: 20, trailing: 16)
                section.interGroupSpacing = 8
                
                return section
                
            case .allMagazine:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(466))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(466))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.boundarySupplementaryItems = [headerItem]
                section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 16, bottom: 56, trailing: 16)
                section.interGroupSpacing = 56
                
                return section
            }
        }
        
        layout.register(BackgroundDecorationView.self, forDecorationViewOfKind: SupplementaryViewKind.background)
        
        return layout
    }
    
    private func configureDataSource() {
        // MARK: Data Source Initialization
        dataSource = .init(collectionView: magazineCollectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
            let section = self.sections[indexPath.section]
            switch section {
            case .mainBanner:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MagazineMainCell.identifier, for: indexPath) as! MagazineMainCell
                cell.configureCell(item.magazine!)
                
                return cell
                
            case .newPerfume:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MagazineNewPerfumeCell.identifier, for: indexPath) as! MagazineNewPerfumeCell
                cell.configureCell(item.newPerfume!)
                
                return cell
                
            case .topReview:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MagazineTopReviewCell.identifier, for: indexPath) as! MagazineTopReviewCell
                cell.configureCell(item.topReview!)
                
                return cell
                
            case .allMagazine:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MagazineAllCell.identifier, for: indexPath) as! MagazineAllCell
                cell.configureCell(item.magazine!)
                
                return cell
            }
        })
        
        // MARK: Supplementary View Provider
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath -> UICollectionReusableView? in
            print(kind)
            switch kind {
            case SupplementaryViewKind.header:
                let section = self.sections[indexPath.section]
                let sectionTitle: String
                let sectionDescription: String
                switch section {
                case .newPerfume:
                    sectionTitle = "출시향수"
                    sectionDescription = "새롭게 출시된 향수를 확인해보세요."
                case .topReview:
                    sectionTitle = "TOP 10 시향기"
                    sectionDescription = "리뷰로 느껴보는 향수"
                case .allMagazine:
                    sectionTitle = "HMOA\nNEWS / 매거진"
                    sectionDescription = "향모아가 전하는 향수 트렌드 이슈"
                default:
                    return nil
                }
                
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: SupplementaryViewKind.header, withReuseIdentifier: MagazineHeaderView.identifier, for: indexPath) as! MagazineHeaderView
                headerView.configureHeader(sectionTitle, sectionDescription)
                
                return headerView
                
            default:
                return nil
            }
        }
        
        // MARK: Initial Snapshot
        var initialSnapshot = NSDiffableDataSourceSnapshot<MagazineSection, MagazineItem>()
        initialSnapshot.appendSections([.mainBanner, .newPerfume, .topReview, .allMagazine])
        
        initialSnapshot.appendItems(MagazineItem.mainMagazines, toSection: .mainBanner)
        initialSnapshot.appendItems(MagazineItem.newPerfumes, toSection: .newPerfume)
        initialSnapshot.appendItems(MagazineItem.top10Reviews, toSection: .topReview)
        initialSnapshot.appendItems(MagazineItem.magazines, toSection: .allMagazine)
        
        sections = initialSnapshot.sectionIdentifiers
        dataSource?.apply(initialSnapshot, animatingDifferences: false)
    }
    
    private func updateSnapshot(forSection section: MagazineSection, withItems items: [MagazineItem]) {
        guard let dataSource = self.dataSource else { return }
        
        var snapshot = dataSource.snapshot()
        
        snapshot.appendItems(items, toSection: section)
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}


